# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

# encoding: UTF-8

module Civitas
  class Sorpresa
  
    def initialize (texto, valor, mazo, tipo, tablero)
      @texto = texto
      @valor = valor
      @mazo = mazo
      @tipo = tipo
      @tablero = tablero
    end
  
    def self.new_carcel (tipo, tablero)
      new("", 0, MazoSorpresas.new(), tipo, tablero)
    end
  
    def self.new_cambio_casilla (tipo, tablero, valor, texto)
      new(texto, valor, MazoSorpresas.new(), tipo, tablero)
    end
  
    def self.new_otros (tipo, valor, texto)
      new(texto, valor, Civitas::MazoSorpresas.new(), tipo, Tablero.new(-1))
    end
  
    def self.new_evita_carcel (tipo, mazo)
      new("", 0,mazo, tipo, Tablero.new(-1))    
    end
  
    def aplicar_a_jugador (actual, todos)
      case @tipo
      when Civitas::Tipo_sorpresa::IRCARCEL
        aplicar_a_jugador_ir_carcel(actual, todos)
    
      when Civitas::Tipo_sorpresa::IRCASILLA
        aplicar_a_jugador_ir_casilla(actual, todos)
      
      when Civitas::Tipo_sorpresa::PAGARCOBRAR
        aplicar_a_jugador_pagar_cobrar(actual, todos)
      
      when Civitas::Tipo_sorpresa::PORCASAHOTEL
        aplicar_a_jugador_por_casa_hotel(actual, todos)
      
      when Civitas::Tipo_sorpresa::PORJUGADOR
        aplicar_a_jugador_por_jugador(actual, todos)
      
      when Civitas::Tipo_sorpresa::SALIRCARCEL
        aplicar_a_jugador_salir_carcel(actual, todos) 
      end
    end
  
    private
    def aplicar_a_jugador_ir_casilla (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        casilla_actual = todos[actual].num_casilla_actual
        nueva_posicion = @tablero.nueva_posicion(casilla_actual, Dado.instance.tirar())
        todos[actual].mover_a_casilla (nueva_posicion)
        #casilla.recibe_jugador (actual, todos)
      end
    end
    
    def aplicar_a_jugador_ir_carcel (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].encarcelar(@tablero.num_casilla_carcel)
      end
    end
  
    def aplicar_a_jugador_pagar_cobrar (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor)
      end
    end
  
    def aplicar_a_jugador_por_casa_hotel (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].modificar_saldo(@valor * (todos[actual].cantidad_casas_hoteles()))
      end
    end
  
    def aplicar_a_jugador_por_jugador (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
      
        pagar = Sorpresa.new_otros(Civitas::Tipo_sorpresa::PAGARCOBRAR, @valor*(-1), @texto)
        i = 0
        todos.size().times do
          if (i!=actual)
            pagar.aplicar_a_jugador(i, todos)
            i += 1
          end
        end
        cobrar = Sorpresa.new_otros(Civitas::Tipo_sorpresa::PAGARCOBRAR, @valor*(todos.size()-1), @texto)
        cobrar.aplicar_a_jugador(actual, todos)
      end
    end
  
    def aplicar_a_jugador_salir_carcel(actual, todos)
      tienen = false
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        i=0
        while (i<todos.size() && !tienen)
          tienen = todos[i].tiene_salvoconducto()
          i+=1
        end
        if (!tienen)
          todos[actual].obtener_salvoconducto(self)
          salir_del_mazo()
        end
      end
    end
  
    def informe (actual, todos)
      Diario.instance.ocurre_evento("Se aplica una sorpresa de tipo " + @tipo.to_s + " al jugador " + todos[actual].nombre)
    end
  
    public
    def jugador_correcto(actual, todos)
      return (actual>=0 && actual < 4)
    end
  
    def salir_del_mazo 
      if (@tipo == Civitas::Tipo_sorpresa::SALIRCARCEL)
        @mazo.inhabilitar_carta_especial(self)
      end
    end
  
    def to_s 
      return "Sorpresa{" + "texto=" + @texto + ", valor=" + @valor.to_s + ", mazo=" + @mazo.to_s + ", tipo=" + @tipo.to_s + ", tablero=" + @tablero.to_s + '}'
    end
  
    def usada
      if (tipo == Civitas::Tipo_sorpresa::SALIRCARCEL)
        @mazo.habilitar_carta_especial(self)
      end
    end
    
    def self.prueba
      sorpresas = []
      puts "Constructores: "
      sorpresas.push(self.new_carcel(Civitas::Tipo_sorpresa::IRCARCEL, Tablero.new(-1)))
      sorpresas.push(self.new_cambio_casilla(Civitas::Tipo_sorpresa::IRCASILLA, Tablero.new(-1), 16, "El jugador se desplaza a la casilla n 16"))
      sorpresas.push(self.new_evita_carcel(Civitas::Tipo_sorpresa::SALIRCARCEL, MazoSorpresas.new()))
      sorpresas.push(self.new_otros(Civitas::Tipo_sorpresa::PAGARCOBRAR, 50, "El jugador paga 50 por una multa"))
      sorpresas.push(self.new_otros(Civitas::Tipo_sorpresa::PORCASAHOTEL, 10, "El jugador paga 10 por casa/hotel"))
      sorpresas.push(self.new_otros(Civitas::Tipo_sorpresa::PORJUGADOR, 20, "El jugador recibe 20 (por cada jugador"))
      
      for i in 0...sorpresas.size()
        puts sorpresas[i].to_s
      end
      
      todos = []
      todos.push(Jugador.new("Fernando"))
      todos.push(Jugador.new("Israel"))
      todos.push(Jugador.new("Pedro"))
      
      puts "\nMetodo aplicarAJugador_irCarcel: "
      sorpresas[0].aplicar_a_jugador(0, todos)
      puts todos[0].to_s
      
      puts "\nMetodo aplicarAJugador_salirCarcel: "
      sorpresas[2].aplicar_a_jugador(1, todos)
      puts todos[1].to_s
      
      puts "\nMetodo aplicarAJugador_irCasilla: "
      sorpresas[1].aplicar_a_jugador(0, todos)
      puts todos[0].to_s
      
      puts "\nMetodo aplicarAJugador_pagarCobrar: "
      sorpresas[3].aplicar_a_jugador(0,todos)
      puts todos[0].to_s
    end
  end
end
