var mongoose = require('mongoose');
//creando el esquema para mostrar las habitaciones que no están en una reserva
 var hotelHabitacionesEsquema = mongoose.Schema({
     nombre:String,
     precio:String,
     cantidad:String,
     numPersonas:String
 });

module.exports = mongoose.model('hotelHabitaciones',hotelHabitacionesEsquema);
