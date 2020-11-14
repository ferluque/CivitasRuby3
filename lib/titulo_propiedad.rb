# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class TituloPropiedad
    attr_reader :hipoteca_base, :nombre, :num_casas, :num_hoteles, :precio_compra, :precio_edificar, :propietario, :hipotecado
  
    @@factor_intereses_hipoteca = 1.1
    def initialize(name, ab, fr, hb, pc, pe)
      @nombre = name
      @alquiler_base = ab
      @factor_revalorizacion = fr
      @precio_compra = pc
      @precio_edificar = pe
    
      @hipotecado = false
      @num_casas = @num_hoteles = 0
      @propietario = nil
    end
  
    def actualiza_propietario_por_conversion (jugador)
      @propietario = jugador
    end
  
    def cancelar_hipoteca (jugador)
      result = false
      if (@hipotecado && es_este_el_propietario(jugador))
        jugador.paga(get_importe_cancelar_hipoteca)
        @hipotecado = false;
        result = true
      end
      return result
    end
  
    def cantidad_casas_hoteles
      return @num_casas+@num_hoteles
    end
  
    def comprar (jugador)
      result = false
      if (!tiene_propietario)
        @propietario = jugador
        result = true
        @propietario.paga(@precio_compra)
      end
      return result
    end
  
    def construir_casa (jugador)
      result = false
      if (es_este_el_propietario(jugador))
        @propietario.paga(@precio_edificar)
        @num_casas += 1
        result = true
      end
      return result
    end
    
    def construir_hotel (jugador)
      result = false
      if (es_este_el_propietario(jugador))
        @propietario.paga(precio_edificar)
        @num_casas += 1
        result = true
      end
      return result
    end
  
    def derruir_casas (n, jugador)
      derruidas = false
      if (es_este_el_propietario(jugador) && !@hipotecado && @num_casas >= n)
        @num_casas -= n
        derruidas = true
      end
      return derruidas
    end
  
    private
    def es_este_el_propietario(jugador)
      return (jugador == @propietario)
    end
  
    
    public
    def get_importe_cancelar_hipoteca ()
      return @hipoteca_base*@@factor_intereses_hipoteca
    end
  
    private
    def get_precio_alquiler ()
      precio = 0.0
      if (!(propietario_encarcelado() && @hipotecado))
        precio = @alquiler_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
      end
      return precio    
    end
  
    def get_precio_venta ()
      return (@precio_compra+@factor_revalorizacion*((@num_casas+@num_hoteles)*@precio_edificar))
    end
    
    public
    def hipotecar (jugador)
      salida = false
      if (!@hipotecado && es_este_el_propietario(jugador))
        @propietario.recibe(@hipoteca_base)
        @hipotecado = true
        salida = true
      end
      return salida
    end
  
    private
    def propietario_encarcelado ()
      return (tiene_propietario() && !@propietario.is_encarcelado())
    end
  
    public
    def tiene_propietario ()
      return @propietario != nil
    end
  
    def to_s ()
      return "TituloPropiedad{" + "alquilerBase=" + @alquiler_base.to_s + ", factorRevalorizacion=" + @factor_revalorizacion.to_s + ", hipotecaBase=" + @hipoteca_base.to_s + ", hipotecado=" + @hipotecado.to_s + ", nombre=" + @nombre + ", numCasas=" + @num_casas.to_s + ", numHoteles=" + @num_hoteles.to_s + ", precioCompra=" + @precio_compra.to_s + ", precioEdificar=" + @precio_edificar.to_s + ", propietario= "+@propietario.to_s() + '}'
    end
  
    def tramitar_alquiler (jugador)
      if (tiene_propietario() && (!es_este_el_propietario(jugador)))
        alquiler = get_precio_alquiler()
        jugador.paga_alquiler(alquiler)
        @propietario.recibe(alquiler)
      end
    end
  
    def vender (jugador)
      if (jugador.compare_to(@propietario) != 0 && !@hipotecado)
        @propietario.recibe(get_precio_venta())
        @propietario = jugador
        return true
      end
      return false
    end
  
  end
end
