# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "gestiones_inmobiliarias"

module JuegoTexto
  class Controlador
    def initialize (game, sight)
      @juego = game
      @vista = sight
      @es_final = @juego.final_del_juego
    end
    
    def juega
      separador = "-----------------------------------------------"
      @vista.setCivitasJuego(@juego)
            
      while (!@juego.final_del_juego)
        @vista.actualizarVista
        @vista.pausa
        
        operacion = @juego.siguiente_paso
                    
        puts separador
        puts @juego.get_jugador_actual.nombre
        @vista.mostrarSiguienteOperacion(operacion)
          
         if (operacion != Civitas::Operaciones_juego::PASAR_TURNO)
          @vista.mostrarEventos
        end
          
        if (!@juego.final_del_juego)
          if (operacion == Civitas::Operaciones_juego::COMPRAR)
            respuesta = @vista.comprar
            if (respuesta == Civitas::Respuestas::SI)
              @juego.comprar
            end
            @juego.siguiente_paso_completado(operacion)
          end
            
          if (operacion == Civitas::Operaciones_juego::GESTIONAR)
            @vista.gestionar
            gestion = Civitas::Lista_gestiones[@vista.getGestion]
            ip = @vista.getPropiedad
            op_inm = OperacionInmobiliaria.new(gestion, ip)
              
            if (op_inm.gestion == Civitas::Gestiones_inmobiliarias::CANCELAR_HIPOTECA)
              @juego.cancelar_hipoteca(op_inm.num_propiedad)
            end
            if (op_inm.gestion == Civitas::Gestiones_inmobiliarias::CONSTRUIR_CASA)
              @juego.construir_casa(op_inm.num_propiedad)
            end
            if (op_inm.gestion == Civitas::Gestiones_inmobiliarias::CONSTRUIR_HOTEL)
              @juego.construir_hotel(op_inm.num_propiedad)
            end
            if (op_inm.gestion == Civitas::Gestiones_inmobiliarias::HIPOTECAR)
              @juego.hipotecar(op_inm.num_propiedad)
            end
            if (op_inm.gestion == Civitas::Gestiones_inmobiliarias::VENDER)
              @juego.vender(op_inm.num_propiedad)
            end
            if (op_inm.gestion == Civitas::Gestiones_inmobiliarias::TERMINAR)
              @juego.siguiente_paso_completado(operacion)
            end
              
          end
            
          if (operacion == Civitas::Operaciones_juego::SALIR_CARCEL)
            salida = @vista.salirCarcel
              
            if (salida == Civitas::Salidas_carcel::PAGANDO)
              @juego.salir_carcel_pagando
            end
            if (salida == Civitas::Salidas_carcel::TIRANDO)
              @juego.salir_carcel_tirando
            end
            @juego.siguiente_paso_completado(operacion)
          end
        end
          
          
      end
      puts @juego.ranking

    end
  end
end


