# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#encoding:utf-8

module Civitas
  class Tablero
    attr_reader :num_casilla_carcel, :por_salida, :tiene_juez
    
    def initialize (carcel) 
      if (carcel >= 1)
        @num_casilla_carcel = carcel
      else 
        @num_casilla_carcel = 1
      end
      
      @casillas = Array.new(0)
      @casillas.push(Casilla.new_descanso("Salida"))
      @por_salida = 0
      @tiene_juez = false
    end
  
    private
    def correcto_noargs
      return ((@casillas.size > @num_casilla_carcel) && @tiene_juez)
    end
  
    def correcto (numCasilla)
      return ((correcto_noargs && (numCasilla >= 0) && (numCasilla < @casillas.size)))
    end
    
    public
    def aniade_casilla (casilla)
      if (@casillas.size == @num_casilla_carcel)
        aniadejuez
      end
      @casillas.push(casilla)
      if (@casillas.size == @num_casilla_carcel)
        aniadejuez
      end
    end
    
    def aniadejuez
      if (!@tiene_juez)
        @casillas.push(Casilla.new_juez(@num_casilla_carcel, "Carcel"))
      end
      @tiene_juez = true
    end
    
    def get_casilla (numCasilla)
      return @casillas[numCasilla]
    end
    
    def get_casillas
      return @casillas
    end
    
    def nueva_posicion (actual, tirada)
      if (!@correcto)
        return -1
      else
        if ((actual+tirada)>@casillas.size)
          @porsalida+=1
        end
        return (actual+tirada)%@casillas.size
      end
    end
    
    def calcular_tirada (origen, destino)
      if (destino > origen)
        return (destino-origen)
      else
        return (@casillas.size-origen + destino)
      end
    end
    
    def to_s 
      return "Tablero{" + "num_casilla_carcel=" + @num_casilla_carcel.to_s + "casillas=" + "array" + ", por_salida=" + @por_salida.to_s + ", tiene_juez=" + @tiene_juez.to_s + "}"
    end
    
    def self.prueba
      puts "Constructor: "
      tablero = Tablero.new(10)
      puts tablero.to_s
      
      tablero2 = Tablero.new(50)
      puts tablero2.to_s
      
      puts "Calculo de nueva posicion: "
      tablero.nueva_posicion(0, Dado.instance.tirar())
    end
    
  end
end
