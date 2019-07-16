var mongoose = require('mongoose');
//creando el esquema de usuarios

 var tarjetaEsquema = mongoose.Schema({
     numero:String,
     saldo:Number,
	 clave:String
 });

module.exports = mongoose.model('tarjetas',tarjetaEsquema);


