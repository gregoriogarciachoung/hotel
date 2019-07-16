var mongoose = require('mongoose');
//creando el esquema de usuarios
 var usuarioEsquema = mongoose.Schema({
     correo:String,
     clave:String
 });

module.exports = mongoose.model('usuarios',usuarioEsquema);

