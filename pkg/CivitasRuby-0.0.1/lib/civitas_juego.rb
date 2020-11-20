# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class CivitasJuego
    attr_reader :estado
    def initialize (nombres)
      @jugadores = []
      nombres.size.times do |i|
        @jugadores.push(Jugador.new(nombres[i]))
      end
    
      @gestor_estados = GestorEstados.new()
      @estado = @gestor_estados.estado_inicial
    
      @indice_jugador_actual = Dado.instance.quien_empieza(@jugadores.size)-1
    
      @mazo = MazoSorpresas.new()
      @tablero = Tablero.new(10)
    
      inicializar_mazo_sorpresas (@tablero)
      inicializar_tablero(@mazo)    
    end
  
    private
    def avanza_jugador
      jugador_actual = @jugadores[@indice_jugador_actual]

      posicion_actual = jugador_actual.num_casilla_actual
      tirada = Dado.instance.tirar
      posicion_nueva = @tablero.nueva_posicion(posicion_actual, tirada)
      casilla = @tablero.get_casilla(posicion_nueva)
      jugador_actual.mover_a_casilla(posicion_nueva)
      casilla.recibe_jugador(@indice_jugador_actual, @jugadores)
      contabilizar_pasos_por_salida(jugador_actual)
    end
  
    public
    def cancelar_hipoteca (ip)
      return get_jugador_actual.cancelar_hipoteca(ip)
    end
  
    def comprar
      jugador_actual = @jugadores[@indice_jugador_actual]
      casilla = @tablero.get_casilla(jugador_actual.num_casilla_actual)
      titulo = casilla.titulo_propiedad
      return jugador_actual.comprar(titulo)
    end
  
    def construir_casa (ip)
      return get_jugador_actual.construir_casa(ip)
    end
  
    def construir_hotel (ip)
      return get_jugador_actual.construir_hotel(ip)
    end
  
    private
    def contabilizar_pasos_por_salida (jugador_actual)
      if (@tablero.por_salida > 0)
        jugador_actual.pasa_por_salida
      end
    end
  
    public
    def final_del_juego
      bancarrota = false
      i = 0
      while (i<@jugadores.size && !bancarrota)
        bancarrota = @jugadores[i].en_bancarrota
        i+=1
      end
      return bancarrota
    end
  
    def get_casilla_actual
      return @tablero.get_casilla(@jugadores[@indice_jugador_actual].num_casilla_actual)
    end
  
    def get_jugador_actual
      return @jugadores[@indice_jugador_actual]
    end
  
    def hipotecar (ip)
      return get_jugador_actual.hipotecar(ip)
    end
  
    def info_jugador_texto
      return get_jugador_actual.to_s
    end
  
    private
    def inicializar_mazo_sorpresas (tablero)
      @mazo.al_mazo(Sorpresa.new_carcel(Civitas::Tipo_sorpresa::IRCARCEL, @tablero))
      @mazo.al_mazo(Sorpresa.new_cambio_casilla(Civitas::Tipo_sorpresa::IRCASILLA, @tablero, 16, "El jugador se desplaza a la casilla n 16"))
      @mazo.al_mazo(Sorpresa.new_evita_carcel(Civitas::Tipo_sorpresa::SALIRCARCEL, @mazo))
      @mazo.al_mazo(Sorpresa.new_otros(Civitas::Tipo_sorpresa::PAGARCOBRAR, -50, "El jugador paga 50 por una multa"))
      @mazo.al_mazo(Sorpresa.new_otros(Civitas::Tipo_sorpresa::PORCASAHOTEL, -10*get_jugador_actual.cantidad_casas_hoteles, "El jugador paga 10 por cada casa y por cada hotel"))
      
      @mazo.al_mazo(Sorpresa.new_otros(Civitas::Tipo_sorpresa::PORJUGADOR, 20*(@jugadores.size()-1), "El jugador recibe 20 por cada jugador"))
      @mazo.al_mazo(Sorpresa.new_otros(Civitas::Tipo_sorpresa::PAGARCOBRAR, 100, "Regalo de cumpleanios: el jugador recibe 100"))
      @mazo.al_mazo(Sorpresa.new_otros(Civitas::Tipo_sorpresa::PORJUGADOR, 10*get_jugador_actual.cantidad_casas_hoteles, "El jugador recibe 10 de cada jugador"))
      @mazo.al_mazo(Sorpresa.new_otros(Civitas::Tipo_sorpresa::PORCASAHOTEL, 5*get_jugador_actual.cantidad_casas_hoteles, "El jugador recibe 5 por cada casa y por cada hotel"))
      @mazo.al_mazo(Sorpresa.new_carcel(Civitas::Tipo_sorpresa::IRCARCEL, @tablero))
    end
  
    def inicializar_tablero (mazo)
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Calle Ganivet", 8.0, 1.1, 35.0, 50.0, 10.0)))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Calle Pedro Antonio de Alarcon", 12.0, 1.12, 45.0, 75.0, 25.0)))
      @tablero.aniade_casilla(Casilla.new_sorpresa(mazo, "Casilla Sorpresa"))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Avenida Juan Pablo II", 17.0, 1.15, 75.0, 125.0, 35.0)))
      @tablero.aniade_casilla(Casilla.new_impuesto(50.0, "Impuesto de circulacion"))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Joaquina Eguaras", 25.0, 1.2, 85.0, 175.0, 50.0)))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Gran Via", 30.0, 1.25, 95.0, 200.0, 60.0)))
      @tablero.aniade_casilla(Casilla.new_sorpresa(mazo, "Casilla Sorpresa"))
      #Se aniade automáticamente la carcel
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Avenida de Madrid", 35.0, 1.27, 105.0, 225.0, 65.0)))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Avenida de Andalucia", 40.0, 1.29, 120.0, 250.0, 80.0)))
      @tablero.aniade_casilla(Casilla.new_impuesto(150.0, "Impuesto de sociedades"))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Avenida de la Constitucion", 50.0, 1.31, 140.0, 275.0, 90.0)))
      @tablero.aniade_casilla(Casilla.new_descanso("Descanso"))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Avenida de Pulianas", 60.0, 1.33, 160.0, 300.0, 100.0)))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Acera del Darro", 75.0, 1.35, 170.0, 350.0, 110.0)))
      @tablero.aniade_casilla(Casilla.new_impuesto(200.0, "IRPF"))
      @tablero.aniade_casilla(Casilla.new_sorpresa(mazo, "Casilla Sorpresa"))
      @tablero.aniade_casilla(Casilla.new_calle(TituloPropiedad.new("Paseo de los tristes",80.0, 1.34, 175.0, 315.0, 115.0)))
    end
  
    def pasar_turno
      @indice_jugador_actual = (@indice_jugador_actual+1)%@jugadores.size
    end
  
    public
    def ranking
      ordenado = @jugadores
      ordenado = ordenado.sort
      ordenado = ordenado.reverse
      return ordenado
    end
  
    def salir_carcel_pagando
      return get_jugador_actual.salir_carcel_pagando
    end
  
    def salir_carcel_tirando
      return get_jugador_actual.salir_carcel_tirando
    end
  
    def siguiente_paso
      jugador_actual = @jugadores[@indice_jugador_actual]
      operacion = @gestor_estados.operaciones_permitidas(jugador_actual, @estado)
      if (operacion == Civitas::Operaciones_juego::PASAR_TURNO)
        pasar_turno
        siguiente_paso_completado(operacion)
      else 
        if (operacion == Civitas::Operaciones_juego::AVANZAR)
          avanza_jugador
          siguiente_paso_completado(operacion)
        end
      end
      return operacion
    end
    
  
    def siguiente_paso_completado (operacion)
      @estado = @gestor_estados.siguiente_estado(get_jugador_actual, @estado, operacion)
    end
  
    def vender (ip)
      return get_jugador_actual.vender(ip)
    end
  
    def to_s
      return "CivitasJuego{" + "indiceJugadorActual=" + @indiceJugadorActual.to_s + ", mazo=" + @mazo.to_s + ", tablero=" + @tablero.to_s + ", jugadores=" + @jugadores.to_s + ", estado=" + @estado.to_s + ", gestorEstados=" + @gestorEstados.to_s + '}'
    end
  
    def self.prueba 
      nombres = []
      nombres.push("Fernando")
      nombres.push("Israel")
      nombres.push("Pedro")
    
      juego = CivitasJuego.new(nombres)
      puts juego.to_s
    end
  end
end
