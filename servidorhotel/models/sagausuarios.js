var mongoose = require('mongoose');
//creando el esquema de usuarios
 var sagausuarioEsquema = mongoose.Schema({
     correo:String,
     dni:String,
     nombre:String,
     usu:String,
     pass:String
 });

module.exports = mongoose.model('sagausuarios',sagausuarioEsquema);
