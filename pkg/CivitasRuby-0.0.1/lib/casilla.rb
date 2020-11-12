# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

# encoding: UTF-8

module Civitas
  class Casilla
    
    attr_reader :nombre, :titulo_propiedad
    
    @@carcel = -1

    def initialize (nombre, tipo, titulo, num_casilla_carcel, mazo, importe = 0)
      @nombre = nombre
      @tipo = tipo
      @titulo_propiedad = titulo
      @importe = importe
      @@carcel = num_casilla_carcel
      @mazo = mazo
      @sorpresa = nil
    end
    
    def self.new_descanso (name)
      new(name, nil, Civitas::Tipo_casilla::DESCANSO, -1, nil)      
    end
    
    def self.new_calle (titulo)
      new("", Civitas::Tipo_casilla::CALLE, titulo, -1, nil)
    end
    
    def self.new_impuesto(cantidad, name)
      new(name, Civitas::Tipo_casilla::IMPUESTO, nil, -1, nil, cantidad)
    end
    
    def self.new_juez(num_casilla_carcel, name)
      new(name, Civitas::Tipo_casilla::JUEZ, nil, num_casilla_carcel, nil)
    end
    
    def self.new_sorpresa(mazo, name)
      new(name, Civitas::Tipo_casilla::SORPRESA, nil, -1, mazo)
    end
    
    private
    def informe (actual, todos)
      Diario.Instance.ocurre_evento("El jugador "+todos[actual].nombre+" ha caido en la casilla "+nombre)
    end
    
    public
    def jugador_correcto(actual, todos)
      return (actual>=0 && actual<todos.size())
    end
    
    private
    # A implementar posteriormente
    def recibe_jugador_calle (actual, todos)
      
    end
    
    def recibe_jugador_impuesto (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].paga_impuesto(@importe)
      end
    end
    
    def recibe_jugador_juez (actual, todos)
      if (jugador_correcto(actual, todos))
        informe(actual, todos)
        todos[actual].encarcelar(@@carcel)
      end
    end
    
    # A implementar posteriormente
    def recibe_jugador_sopresa(actual, todos)
      
    end
    
    public
    def to_s
      devolver = "Casilla{" + "importe=" + @importe.to_s + ", nombre=" + @nombre + ", tipo=" + @tipo.to_s + ", titulo_propiedad=" + @titulo_propiedad.to_s + ", sorpresa=" + @sorpresa.to_s + ", mazo=" + @mazo.to_s + '}'
      return devolver
    end
      
    def self.prueba
      descanso = Casilla.new_descanso("Descanso")
      puts descanso.to_s
      
      calle = Casilla.new_calle(TituloPropiedad.new("Gran Via", 150.0, 1.2,200.0,250.0,50.0))
      puts calle.to_s
      
      impuesto = Casilla.new_impuesto(100.0, "Impuesto de luz")
      puts impuesto.to_s
      
      juez = Casilla.new_juez(10, "Carcel")
      puts juez.to_s
      
      sorpresa = Casilla.new_sorpresa(MazoSorpresas.new(), "Casilla Sorpresa")
      puts sorpresa.to_s
    end
  end
  
end
