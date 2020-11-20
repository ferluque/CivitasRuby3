# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

# encoding: UTF-8

module Civitas 
  class MazoSorpresas
    def initialize (d=false)
      init
      @debug = d
      if (@debug)
        Diario.ocurre_evento("Modo debug del mazo activado")
      end
      @cartas_especiales = []
      @ultima_sorpresa
    end
    
    private
    def init
      @sorpresas = Array.new(0)
      @cartas_especiales = Array.new(0)
      @barajado = false
      @usadas = 0
    end
    
    public
    def al_mazo (nueva)
      if (!@barajado)
        @sorpresas.push(nueva)
      end
    end
    
    def siguiente 
      if ((!@barajado || (@sorpresas.size == @usadas)) && !@debug)
        puts "Se baraja el mazo"
        @barajada = true
        @usadas = 0
        @sorpresas.shuffle!
      end
      @usadas += 1
      @ultima_sorpresa = @sorpresas.shift
      @sorpresas.push(@ultima_sorpresa)
      return @ultima_sorpresa
    end
    
    def inhabilitar_carta_especial (sorpresa)
      if (@sorpresas.include?(sorpresa))
        @sorpresas.delete(sorpresa) 
        @cartas_especiales.push(sorpresa)
        Diario.instance.ocurre_evento("Se ha anulado una carta especial")
      end
    end
    
    def habilitar_carta_especial (sorpresa)
      if (@cartas_especiales.include?(sorpresa))
        @cartas_especiales.delete(sorpresa)
        @sorpresas.push(sorpresa)
        Diario.instance.ocurre_evento("Se ha habilitado una carta especial")
      end
    end 
    
    def self.prueba 
      mazo = MazoSorpresas.new()
      sorpresa1 = Sorpresa.new_carcel(Civitas::Tipo_sorpresa::IRCARCEL, Tablero.new(-1))
      sorpresa2 = Sorpresa.new_cambio_casilla(Civitas::Tipo_sorpresa::IRCASILLA, Tablero.new(-1), 1, "Ir a casilla n 1")
      mazo.al_mazo(sorpresa1)
      mazo.al_mazo(sorpresa2)
    
      puts mazo.to_s
    
      puts "Se anula carta especial"
      mazo.inhabilitar_carta_especial(sorpresa2)
      puts mazo.to_s
    
      puts "Se habilita carta especial"
      mazo.habilitar_carta_especial(sorpresa2)
      puts mazo.to_s
    
      while (Diario.instance.eventos_pendientes())
        puts Diario.instance.leer_evento()
      end
    
    end
    
  end
  
end
