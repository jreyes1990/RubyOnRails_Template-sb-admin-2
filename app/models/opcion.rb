# == Schema Information
#
# Table name: opciones
#
#  id                  :bigint           not null, primary key
#  aplica_carga_masiva :string(10)
#  codigo_hex          :string
#  controlador         :string(300)
#  descripcion         :string
#  estado              :string(10)
#  icono               :string(50)
#  nombre              :string(200)
#  path                :string
#  posicion            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  menu_id             :bigint           not null
#  user_created_id     :integer
#  user_updated_id     :integer
#
# Indexes
#
#  index_opciones_on_menu_id  (menu_id)
#
# Foreign Keys
#
#  fk_rails_...  (menu_id => menus.id)
#
class Opcion < ApplicationRecord
  belongs_to :menu

  has_many :menu_roles
  has_many :opcion_cas
  
  validates_presence_of :nombre, :path, :controlador, :menu_id, :estado, message: ": este campo es obligatorio"
  validates :nombre, uniqueness: {case_sensitive: false, scope: [:icono, :codigo_hex, :path, :controlador, :menu_id, :estado], message: "El Menú-Opción que intenta registrar ya existe" }
end
