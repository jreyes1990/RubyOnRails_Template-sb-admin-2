class MenuRolDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  #Definición de los Helpers de la vista
  def_delegator :@view, :link_to
  #def_delegator :@view, :tiene_permiso
  def_delegator :@view, :edit_menu_rol_path
  def_delegator :@view, :menu_rol_path
  def_delegator :@view, :inactivar_menu_rol_path
  def_delegator :@view, :activar_menu_rol_path

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id: { source: "MenuRolView.id", cond: :eq },
      nombre_rol: { source: "OpcionView.nombre_rol", cond: :like },
      nombre_menu: { source: "OpcionView.nombre_menu", cond: :like },
      nombre_opcion: { source: "OpcionView.nombre_opcion", cond: :like },
      estado: { source: "OpcionView.estado", cond: :like },
      opciones: { source: "", searchable: false, orderable: false},
      inactivar: { source: "", searchable: false, orderable: false}
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        nombre_rol: estilo_codigo_hex_menu_rol(record),
        nombre_menu: record.nombre_menu,
        nombre_opcion: record.nombre_opcion,
        estado: format_estado(record),
        opciones: show_btn_opcion(record),
        inactivar: show_btn_inactivar(record)
      }
    end
  end

  def get_raw_records
    MenuRolView.order(id: :DESC)
  end

  def show_btn_opcion(record)
    btnOpcion = nil
    #if tiene_permiso("BOTON EDITAR REGISTRO", "VER") || tiene_permiso("BOTON ELIMINAR REGISTRO", "VER")
      if record.estado == 'A'
        #if tiene_permiso("BOTON EDITAR REGISTRO", "VER")
          btnOpcion =  link_to("<i class='fas fa-edit'></i>".html_safe, edit_menu_rol_path(record), class: "btn btn-outline-info btn-sm rounded-circle") 
        #else
        #  btnOpcion = ""
        #end
      else
        #if tiene_permiso("BOTON ELIMINAR REGISTRO", "VER")
          btnOpcion =  link_to("<i class='fas fa-trash-alt'></i>".html_safe, menu_rol_path(record.id), class: "btn btn-outline-danger btn-sm rounded-circle", method: :delete, data: {controller: 'sweetalert', action: 'click->sweetalert#btnInactivar',
                                                                                                                                                                                  sweetalert_confirm_alert_value: "Eliminar",
                                                                                                                                                                                  sweetalert_cancel_alert_value: "Cancelado",
                                                                                                                                                                                  sweetalert_confirm_title_value: 'Esta seguro de eliminar <strong style="color: #1d71b9; font-weight: bold;"><p>'+"#{record.nombre_opcion}-#{record.nombre_rol.capitalize}?"+'</p></strong>',
                                                                                                                                                                                  sweetalert_confirm_btn_value: '<i class="fas fa-check-circle"></i> <strong>Si, Eliminar</strong>',
                                                                                                                                                                                  sweetalert_cancel_btn_value: '<i class="fas fa-times-circle"></i> <strong>No, Cancelar</strong>',
                                                                                                                                                                                  sweetalert_cancel_title_value: 'Se ha cancelado la aliminación de <strong>'+"#{record.nombre_opcion}-#{record.nombre_rol.capitalize}"+'</strong>' }) 
        #else
        #  btnOpcion = ""
        #end
      end
    #else
    #  btnOpcion = ""
    #end
    return btnOpcion
  end

  def show_btn_inactivar(record)
    btnInactivar = nil
    #if tiene_permiso("BOTON INACTIVAR REGISTRO", "VER")
    if record.estado == 'A'
      btnInactivar = link_to("<i class='fas fa-toggle-on' style='transform: rotate(360deg);'></i>".html_safe, inactivar_menu_rol_path(:id => record.id), class: "btn btn-outline-danger btn-sm rounded-circle", data: {controller: 'sweetalert', action: 'click->sweetalert#btnInactivar',
                                                                                                                                                                                                                    sweetalert_confirm_alert_value: "Inactivar",
                                                                                                                                                                                                                    sweetalert_cancel_alert_value: "Cancelado",
                                                                                                                                                                                                                    sweetalert_confirm_title_value: 'Esta seguro de inactivar <strong style="color: #1d71b9; font-weight: bold;"><p>'+"#{record.nombre_opcion}-#{record.nombre_rol.capitalize}?"+'</p></strong>',
                                                                                                                                                                                                                    sweetalert_confirm_btn_value: '<i class="fas fa-check-circle"></i> <strong>Si, Inactivar</strong>',
                                                                                                                                                                                                                    sweetalert_cancel_btn_value: '<i class="fas fa-times-circle"></i> <strong>No, Cancelar</strong>',
                                                                                                                                                                                                                    sweetalert_cancel_title_value: 'Se ha cancelado la inactivación de <strong>'+"#{record.nombre_opcion}-#{record.nombre_rol.capitalize}"+'</strong>' }) 
    else
      btnInactivar = link_to("<i class='fas fa-toggle-on' style='transform: rotate(180deg);'></i>".html_safe, activar_menu_rol_path(:id => record.id), class: "btn btn-outline-success btn-sm rounded-circle", data: {controller: 'sweetalert', action: 'click->sweetalert#btnInactivar',
                                                                                                                                                                                                                  sweetalert_confirm_alert_value: "Activar",
                                                                                                                                                                                                                  sweetalert_cancel_alert_value: "Cancelado",
                                                                                                                                                                                                                  sweetalert_confirm_title_value: 'Esta seguro de activar <strong style="color: #1d71b9; font-weight: bold;"><p>'+"#{record.nombre_opcion}-#{record.nombre_rol.capitalize}?"+'</p></strong>',
                                                                                                                                                                                                                  sweetalert_confirm_btn_value: '<i class="fas fa-check-circle"></i> <strong>Si, Activar</strong>',
                                                                                                                                                                                                                  sweetalert_cancel_btn_value: '<i class="fas fa-times-circle"></i> <strong>No, Cancelar</strong>',
                                                                                                                                                                                                                  sweetalert_cancel_title_value: 'Se ha cancelado la activación de <strong>'+"#{record.nombre_opcion}-#{record.nombre_rol.capitalize}"+'</strong>' }) 
    end
    #else
    #  btnInactivar = ""
    #end
    return btnInactivar
  end

  def format_estado(record)
    if record.estado == 'A'
      badge_estado = "badge badge-success"
      nombre_estado = "Activo"
    else
      badge_estado = "badge badge-danger"
      nombre_estado = "Inactivo"
    end

    return "<div class='text-center'><span class='#{badge_estado}'>#{nombre_estado}</span></div>".html_safe
  end

  def estilo_codigo_hex_menu_rol(record)
    return "<div class='text-center'><strong style='color: #{record.codigo_hex_rol};'>#{record.nombre_rol.upcase}</strong></div>".html_safe
  end
end
