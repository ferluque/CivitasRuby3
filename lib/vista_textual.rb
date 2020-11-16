#encoding:utf-8
require 'io/console'

module JuegoTexto

  class VistaTextual
    
    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l.to_s
        index += 1
      }

      opcion = lee_entero(lista.length,
        "\n"+tab+"Elige una opción: ",
        tab+"Valor erróneo")
      return opcion
    end

    
    def comprar
      opcion = menu("¿Deseas comprar la calle a la que has llegado? ",
        ["SI", "NO"]);
      respuesta = Civitas::Lista_respuestas[opcion]
      return respuesta
    end

    def gestionar
      gestiones = []
      Civitas::Lista_gestiones.size.times do |i|
        gestiones.push(Civitas::Lista_gestiones[i])
      end
      
      opcion = menu("¿Que gestion inmobiliaria desea realizar?", gestiones)
      @iGestion = opcion;
      
      propiedades = []
      @juegoModel.get_jugador_actual.propiedades.length.times do |i|
        propiedades.push(@juegoModel.get_jugador_actual.propiedades[i].to_s)
      end
      opcion = menu("¿Sobre que propiedad deseas hacer la gestion?", propiedades)
      @iPropiedad = opcion
    end

    def getGestion
      return @iGestion
    end

    def getPropiedad
      return @iPropiedad
    end

    def mostrarSiguienteOperacion(operacion)
      puts operacion.to_s
    end

    def mostrarEventos
      while (Civitas::Diario.instance.eventos_pendientes)
        puts Civitas::Diario.instance.leer_evento
      end
    end

    def setCivitasJuego(civitas)
      @juegoModel=civitas
      self.actualizarVista
    end

    def actualizarVista
      puts @juegoModel.get_jugador_actual.to_s
      puts @juegoModel.get_casilla_actual.to_s
    end

    def salirCarcel
      opcion = menu("Elige la forma para intentar salir de la carcel: ",
        ["Pagando", "Tirando el dado"])
      return Civitas::Lista_salidas[opcion]
    end
    
  end

end
