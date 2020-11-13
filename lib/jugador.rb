# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Jugador
    
    attr_reader :casas_max, :casas_por_hotel, :hoteles_max, 
      :nombre, :num_casilla_actual, :precio_libertad, :paso_por_salida, 
      :propiedades, :puede_comprar, :saldo, :encarcelado
    
    @@casas_max = 4
    @@casas_por_hotel = 4
    @@hoteles_max = 4
    @@paso_por_salida = 1000.0
    @@precio_libertad = 200.0
    @@saldo_inicial = 7500.0
    
    def initialize (name, encarcelado = false, num_casilla_actual=0, puede_comprar=false, saldo=0.0, propiedades=[])
      @nombre = name
      @encarcelado = encarcelado
      @num_casilla_actual = num_casilla_actual
      @puede_comprar = puede_comprar
      @saldo = saldo
      @propiedades = propiedades
    end
    
    def constr_copia (otro)
      new(otro.nombre, otro.encarcelado, otro.num_casilla_actual, otro.puede_comprar, otro.saldo, otro.propiedades)
    end
    
    ######################

    def cancelar_hipoteca (ip)
      result = false
      if (@encarcelado)
        return result
      end
      if (existe_la_propiedad(ip))
        propiedad = @propiedades[ip]
        cantidad = propiedad.get_importe_cancelar_hipoteca
        puedo_castar = puedo_gastar(cantidad)
        if (puedo_gastar)
          result = propiedad.cancelar_hipoteca(self)
          if (result)
            Diario.instance.ocurre_evento("El jugador " + @nombre + " cancela la hipoteca de la propiedad "+ propiedad.nombre)
          end
        end
      end
      return result
    end
    
    def cantidad_casas_hoteles 
      cantidad = 0
      i = 0
      @propiedades.size.times do
        cantidad += @propiedades.get(i).cantidad_casas_hoteles
        i += 1
      end
      return cantidad
    end
    
    def compare_to (otro)
      return Float.compare(@saldo, otro.saldo)
    end
    
    #Prácticas posteriores
    def comprar (titulo)
      result = false
      if (@encarcelado)
        return result
      end
      if (@puede_comprar)
        if (puedo_gastar(titulo.precio_compra))
          result = titulo.comprar(self)
          if (result)
            @propiedades.push(titulo)
            Diario.instance.ocurre_evento("El jugador "+@nombre+" compra la propiedad "+titulo.nombre)
          end
          puede_comprar = false;
        end
      end
      return result
    end
    def construir_casa (ip)
      result = false
      if (@encarcelado)
        return result
      else
        existe = existe_la_propiedad(ip)
      end
      if (existe)
        propiedad = @propiedades[ip]
        if (puedo_edificar_casa(propiedad))
          result = propiedad.construir_casa(self)
          if (result)
            Diario.instance.ocurre_evento("El jugador " + @nombre + " construye una casa en la propiedad " + propiedad.nombre)
          end
        end
      end
      
    end
    
    def construir_hotel (ip)
      result = false
      if (@encarcelado)
        return result
      end
      if (existe_la_propiedad(ip))
        propiedad = @propiedades[ip]
        if (puedo_edificar_hotel(propiedad))
          result = propiedad.construir_hotel(self)
          casas_x_hotel = @@casas_por_hotel
          propiedad.derruir_casas(casas_x_hotel, self)
          Diario.instance.ocurre_evento("El jugador "+@nombre+" construye un hotel en la propiedad "+propiedad.nombre)
        end
      end
      return result
    end
    
    def hipotecar (ip)
      result = false
      if (@encarcelado)
        return result
      end
      if (existe_la_propiedad(ip))
        propiedad = @propiedades[ip]
        result = propiedad.hipotecar(self)
        if (result)
          Diario.instance.ocurre_evento("El jugador "+@nombre+" hipoteca la propiedad "+propiedad.nombre)
        end
      end
    end
    
    private
    def debe_ser_encarcelado 
      resultado = false
      if (!@encarcelado)
        if (tiene_salvoconducto)
          perder_salvoconducto
          Diario.Instance.ocurre_evento("Jugador "+ @nombre + " se libra de la carcel")
        else
          resultado = true
        end
      end
      return resultado
    end
    
    public
    def en_bancarrota
      return @saldo <= 0
    end
    
    def encarcelar (num_casilla_carcel)
      if (debe_ser_encarcelado())
        mover_a_casilla(num_casilla_carcel)
        @encarcelado = true
        Diario.instance.ocurre_evento("El jugador " + @nombre + " es encarcelado")
      end
      return @encarcelado
    end
    
    private
    def existe_la_propiedad (ip)
      return (ip >= 0 && ip<@propiedades.size)
    end
    
    public
    def modificar_saldo (cantidad)
      @saldo += cantidad
      Diario.instance.ocurre_evento("Se aniaden " + cantidad.to_s + " al saldo del jugador " + @nombre)
      return true
    end
    
    def mover_a_casilla (num_casilla)
      if (@encarcelado)
        return false
      else
        @num_casilla_actual = num_casilla
        @puede_comprar = false
        Diario.instance.ocurre_evento("El jugador " + @nombre + " se desplaza a la casilla " + @num_casilla.to_s)
        return true
      end
    end
    
    def obtener_salvoconducto (sorpresa)
      if (@encarcelado)
        return false
      else
        @salvoconducto = sorpresa
        return true
      end
    end
    
    def paga (cantidad)
      return modificar_saldo(cantidad*(-1))
    end
    
    def paga_alquiler (cantidad)
      if (@encarcelado)
        return false
      else
        return paga(cantidad)
      end
    end
    
    def paga_impuesto (cantidad)
      if (@encarcelado)
        return false
      else
        return paga(cantidad)
      end
    end
    
    def pasa_por_salida 
      modificar_saldo(@@paso_por_salida)
      Diario.instance.ocurre_evento("El jugador " + @nombre + " pasa por salida")
      return true
    end
    
    private
    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto = 0
    end
    
    public
    def puede_comprar_casilla
      @puede_comprar = !@encarcelado
      return @puede_comprar
    end
    
    private
    def puede_salir_carcel_pagando
      return @saldo >= @@precio_por_libertad
    end
    
    def puedo_edificar_casa (propiedad)
      assert(@propiedades.include?(propiedad))
      return puedo_gastar(propiedad.precio_edificar)
    end
    
    def puedo_edificar_hotel (propiedad)
      assert(@propiedades.include?(propiedad))
      return (puedo_edificar_casa(propiedad) && propiedad.num_casas >= 4)
    end
    
    def puedo_gastar(precio)
      if (@encarcelado)
        return false
      else
        return @saldo >= precio
      end
    end
    
    public
    def recibe (cantidad)
      if (encarcelado)
        return false
      else 
        return modificar_saldo(cantidad)
      end
    end
    
    def salir_carcel_pagando 
      if (@encarcelado && puede_salir_carcel_pagando())
        paga (@@precio_libertad)
        Diario.Instance.ocurre_evento("El jugador " + @nombre + " paga " + @@PrecioLibertad + " por salir de la carcel")
        return true
      end
      return false
    end
    
    def salir_carcel_tirando
      if (@encarcelado && Dado.Instance.salgo_de_la_carcel())
        @encarcelado = false
        Diario.Instance.ocurre_evento("El jugador " + @nombre + " sale de la carcel tirando el dado")
      end
      return !@encarcelado
    end
    
    def tiene_algo_que_gestionar
      return @propiedades.size() > 0
    end
    
    def tiene_salvoconducto 
      return (@salvconducto != nil)
    end
    
    def vender (ip)
      if (!@encarcelado && existe_la_propiedad(ip))
        if (@propiedades[ip].vender(self))
          evento = @nombre + " ha vendido la propiedad " + @propiedades[ip].nombre
          Diario.instance.ocurre_evento(evento)
          @propiedades.delete(@propiedades[ip])
          return true
        end
      end
      return false
    end
    
    def to_s
      "Jugador{" + "encarcelado=" + @encarcelado.to_s + ", nombre=" + @nombre + ", numCasillaActual=" + @numCasillaActual.to_s + ", puedeComprar=" + @puedeComprar.to_s + ", saldo=" + @saldo.to_s + ", propiedades=" + @propiedades.to_s + ", salvoconducto=" + @salvoconducto.to_s + '}'
    end
    
    def self.prueba
      jugador = Jugador.new("Fernando")
      puts jugador.to_s
  
      jugador.obtener_salvoconducto(Sorpresa.new_evita_carcel(Civitas::Tipo_sorpresa::SALIRCARCEL, MazoSorpresas.new()))
      puts jugador.to_s
  
      jugador.encarcelar (10)
      puts jugador.to_s
    end
  end
  


  
  
end
