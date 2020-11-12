# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


require_relative "tablero"
require_relative "dado"
require_relative "estados_juego"
require_relative "tipo_casilla"
require_relative "tipo_sorpresa"
require_relative "mazo_sorpresas"
require_relative "diario"
require_relative "sorpresa"
require_relative "casilla"


module Civitas
  
    
  # Muestra al menos un valor de cada enumerado
  if true
    puts ("Estados_juego.INICIO_TURNO: " + Civitas::Estados_juego::INICIO_TURNO.to_s)
    puts ("Tipo_casilla.SORPRESA: " + Civitas::Tipo_casilla::SORPRESA.to_s)
    puts ("Tipo_sorpresa.IRCARCEL" + Civitas::Tipo_sorpresa::IRCARCEL.to_s)
  end
    # Revisar como poner eso
  
  
  # 5 y 6: Crea un objeto MazoSorpresas y haz pruebas
  if true
    mazo = MazoSorpresas.new()
    mazo.al_mazo(Sorpresa.new())
    mazo.al_mazo(Sorpresa.new())
    Diario.instance.ocurre_evento("Se aniaden dos sorpresas")
    puts Diario.instance.leer_evento
    mazo.siguiente
    mazo.inhabilitar_carta_especial (Sorpresa.new)
  end
  
  # 7: Tablero y pruebas
  
  
  
end
  
  
