# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


#encoding:utf-8

require_relative "tipo_casilla"
require_relative "tipo_sorpresa"
require_relative "operaciones_juego"
require_relative "estados_juego"

require_relative "casilla"
require_relative "dado"
require_relative "diario"
require_relative "gestor_estados"
require_relative "jugador"
require_relative "mazo_sorpresas"
require_relative "sorpresa"
require_relative "tablero"
require_relative "titulo_propiedad"
require_relative "civitas_juego"

module Civitas  
  puts "\nPrueba Casilla: "
  Casilla.prueba
  
  puts "\nPrueba Dado: "
  Dado.prueba
  
  puts "\nPrueba Jugador: "
  Jugador.prueba
  
  puts "\nPrueba MazoSorpresas: "
  MazoSorpresas.prueba
  
  puts "\nPrueba Sorpresa: "
  Sorpresa.prueba
  
  puts "\nPrueba Tablero: "
  Tablero.prueba
  
  puts "\nPrueba CivitasJuego: "
  CivitasJuego.prueba

end