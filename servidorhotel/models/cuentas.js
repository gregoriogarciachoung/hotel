var mongoose = require('mongoose');
//creando el esquema de usuarios

  var cuentaEsquema = mongoose.Schema({
     numero:String,
     saldo:Number,
	 clave:String
 });
 
module.exports = mongoose.model('cuentas',cuentaEsquema);

