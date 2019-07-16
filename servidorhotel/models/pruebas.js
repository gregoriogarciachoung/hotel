var mongoose = require('mongoose');
//creando el esquema de usuarios

  var cuentaEsquema = mongoose.Schema({
	 userId: Number,
     id: Number,
     title: String,
     body: String

 });
 
module.exports = mongoose.model('pruebas',cuentaEsquema);
