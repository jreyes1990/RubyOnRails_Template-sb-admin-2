class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]

  def index
    @personas = Persona.select("personas.*, (personas.nombre||' '||personas.apellido) as nombre_completo, users.email as correo_electronico")
                       .joins("inner join users on(personas.user_id=users.id)")
                       .order!("personas.id DESC")
  end

  def search_area_empresa_usuario
    if params[:search_empresa_usuario_params].present?
      parametro = params[:search_empresa_usuario_params].upcase

      @empresa =  Empresa.where("(upper(id|| ' ' ||nombre) like upper('%#{parametro}%')) and estado = 'A' ").limit(50).distinct

      respond_to do |format|
        format.json { render json: @empresa.map { |p| { valor_id: p.id, valor_text: p.informacion_empresa } } }
      end 
    elsif params[:empresa_usuario_params].present?
      empresa_id = params[:empresa_usuario_params]

      @area =  Area.joins("inner join empresas on (areas.empresa_id = empresas.id)")
                      .where("areas.empresa_id = #{empresa_id} and areas.estado = 'A'").limit(50).distinct

      respond_to do |format|
        format.json { 
          render json: {
            area_empresa: @area.map { |p| { valor_id: p.id, valor_text: p.area_con_codigo } }
          }
        }
      end
    end
  end

  def new      
  end

  def agregar_usuario
    @empresa = Empresa.where(:estado =>'A').limit(10)
  end

  def crear_usuario
    @usuario = User.new(usuario_params)    
    @usuario.user_created_id = current_user.id
    @usuario.estado = "A"
    @usuario.password = generate_secure_password
    @nombre_completo = params[:usuario_form][:nombre] + " " + params[:usuario_form][:apellido]

    begin
      respond_to do |format|
        if @usuario.save
          @persona = Persona.where("user_id = ?", @usuario.id).first

          if @persona.update(persona_params)
            @consulta_area = AreaView.where(id: params[:usuario_form][:area_id]).first

            @persona_areas = PersonasArea.new
            @persona_areas.persona_id = @persona.id
            @persona_areas.area_id = @consulta_area.id
            @persona_areas.estado = 'A'
            @persona_areas.user_created_id = current_user.id

            if @persona_areas.save
              # Envío de correo electrónico
              puts "ENVIANDO CORREO ELECTRONICO"
              puts "EMPRESA: #{@consulta_area.nombre_empresa}"
              puts "AREA: #{@consulta_area.nombre}"
              puts "NOMBRE COMPLETO: #{@nombre_completo}"
              puts "EMAIL: #{@usuario[:email]}"
              puts "PASSWORD: #{@usuario[:password]}"
              puts "ENVIAR CORREO A USUARIO: #{params[:usuario_form][:envia_correo_usuario]}"
              puts "ENVIAR TELEGRAM A USUARIO: #{params[:usuario_form][:envia_telegram_usuario]}"

              # Envío de correo electrónico
              if params[:usuario_form][:envia_correo_usuario].upcase == 'S'.upcase
                if internet_connection_available?
                  UsuarioMailer.registro_exitoso(@consulta_area.nombre_empresa, @consulta_area.nombre, @nombre_completo, @usuario.email, @usuario.password).deliver_now
                  puts "SI, HAY CONEXION A INTERNET, PUEDE ENVIAR EL CORREO AL USUARIO"
                  @estado_correo = "ENVIADO"
                else
                  puts "PERDON, NO SE PUDO ENVIAR EL CORREO ELECTRONICO PORQUE NO HAY CONEXION A INTERNET"
                  @estado_correo = "PENDIENTE"
                end
              else
                @estado_correo = "NO ENVIAR"
              end

              # Envía un mensaje a través de Telegram
              if params[:usuario_form][:envia_telegram_usuario].upcase == 'S'.upcase
                if internet_connection_available?
                  message = "Bienvenido a nuestro sistema: \n\nHola <strong>#{@nombre_completo}</strong>!.\nHas sido registrado con éxito en nuestra aplicación.\n\nEmpresa: <strong>#{@consulta_area.nombre_empresa}</strong>\nÁrea: <strong>#{@consulta_area.nombre}</strong>\nEmail: <strong>#{@usuario.email}</strong>\nContraseña: <strong>#{@usuario.password}</strong>\nEnlace App: http://localhost:3000/\n\n<strong>NOTA: </strong>\nPor favor, cambia tu contraseña lo antes posible después de iniciar sesión por primera vez.\n\nSi tienes alguna pregunta, no dudes en contactarnos.".html_safe
                  $telegram_bot.api.send_message(chat_id: params[:usuario_form][:chat_id_telegram], text: message, parse_mode: 'HTML')
                  puts "SI, HAY CONEXION A INTERNET, PUEDE ENVIAR EL TELEGRAM AL USUARIO"
                  @estado_telegram = "ENVIADO"
                else
                  puts "PERDON, NO SE PUDO ENVIAR EL TELEGRAM PORQUE NO HAY CONEXION A INTERNET"
                  @estado_telegram = "PENDIENTE"
                end
              else
                @estado_telegram = "NO ENVIAR"
              end

              genera_credenciales(
                "CREACIÓN USUARIO",
                @consulta_area.empresa_id,
                @consulta_area.nombre_empresa,
                @consulta_area.id,
                @consulta_area.nombre,
                @persona.id,
                @nombre_completo,
                @persona.user_id,
                @usuario[:email],
                @usuario.password,
                params[:usuario_form][:envia_correo_usuario],
                params[:usuario_form][:envia_telegram_usuario],
                @estado_correo,
                @estado_telegram,
                current_user.id,
                nil,
                "A"
              )
              
              format.html { redirect_to usuarios_path, notice: 'El Usuario se ha creado exitosamente.' } 
            else 
              flash[:alert] = "No se pudo asignar la persona a una área, Verifique !!!"
              redirect_to usuarios_path  
            end
          else 
            flash[:alert] = "No se pudo crear la persona, Verifique !!!"
            redirect_to usuarios_path 
          end
        else 
          flash[:alert] = "No se pudo crear la persona, Verifique !!!"
          redirect_to usuarios_path 
        end
      end
    rescue Exception => e
      puts "Error General: #{e.message}"
    end
  end

  def set_usuario   
  end 

  def usuario_params
    params.require(:usuario_form).permit(:email, :password )
  end
  
  def persona_params
    params.require(:usuario_form).permit(:nombre, :apellido, :telefono, :chat_id_telegram, :direccion, :user_created_id, :estado)
  end
end
