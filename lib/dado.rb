# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


# encoding: UTF-8
require "singleton"

module Civitas
  class Dado
    include Singleton
    attr_writer :debug
    attr_reader :ultimo_resultado
  
    @@salida_carcel = 5
    private
    def initialize
      @ultimo_resultado = 0
      @debug = false
    end
  
    public
    def tirar
      if (@debug)
        @ultimo_resultado = 1
      else
        @ultimo_resultado = rand(1..6)
      end
      return @ultimo_resultado
    end
  
    def salgo_de_la_carcel
      estado_anterior = @debug
      @debug = false
      @ultimo_resultado = tirar
      @debug = estado_anterior

      return (@ultimo_resultado == @@salida_carcel)
    end
  
    def quien_empieza (jugadores)
      return rand(1..jugadores);
    end
  
    def set_debug (d)
      @debug = d
      Diario.instance.ocurre_evento("Metodo debug " + d.to_s)
    end
    
    def self.prueba 
      # Generamos 100 números aleatorios entre 1-4 y después mostramos cuántas veces se ha
      # obtenido cada resultado
      if (true) 
        veces1 = 0 
        veces2 = 0
        veces3 = 0
        veces4 = 0
    
        100.times do
          jugador = Dado.instance.quien_empieza(4)
          case jugador
          when 1
            veces1 += 1
          when 2
            veces2 += 1
          when 3
            veces3 += 1
          when 4
            veces4 += 1
          end 
        end
    
        puts "Prob1: " + veces1.to_s + "\nProb2: "+ veces2.to_s + "\nProb3: "+ veces3.to_s + "\nProb4: "+ veces4.to_s
    
      end
  
      # Tiramos 5 veces el dado con debug y 5 sin debug
      if true
        Dado.instance.debug = true
        puts "Debug true"
        5.times do
          puts (Dado.instance.tirar())
        end
      
        Dado.instance.debug = false
        puts "Debug false"
        5.times do
          puts (Dado.instance.tirar())
        end
      end
      
      
      # Tiramos el dado 5 veces para ver si salimos de la carcel
      if true
        5.times do
          if (Dado.instance.salgo_de_la_carcel)
            puts Dado.instance.ultimo_resultado
            puts "Sales de la carcel"
          else
            puts Dado.instance.ultimo_resultado
            puts "No sales de la carcel"
          end
        end
      end
    end
  end
  
  
end
