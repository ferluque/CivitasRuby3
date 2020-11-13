# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  module Gestiones_inmobiliarias
    VENDER = :VENDER
    HIPOTECAR = :HIPOTECAR
    CANCELAR_HIPOTECA = :CANCELAR_HIPOTECA
    CONSTRUIR_CASA = :CONSTRUIR_CASA
    CONSTRUIR_HOTEL = :CONSTRUIR_HOTEL
    TERMINAR = :TERMINAR
  end
  lista_gestiones = [Gestiones_inmobiliarias::VENDER, Gestiones_inmobiliarias::HIPOTECAR, Gestiones_inmobiliarias::CANCELAR_HIPOTECA, Gestiones_inmobiliarias::CONSTRUIR_CASA, Gestiones_inmobiliarias::CONSTRUIR_HOTEL, Gestiones_inmobiliarias::TERMINAR]
end
