 var usuario = require('../models/pruebas');
exports.agregar = function(req,res){
     var miUsuario = new usuario();
     miUsuario.userId = req.body.userId;
     miUsuario.id = req.body.id;
     miUsuario.title = req.body.title;
     miUsuario.body = req.body.body;
     miUsuario.save(function(err,resultado){
         if (err)
         {
             res.status(500)
             .json({mensaje:'Error con el registro'})
         }
         else
         {
             res.status(200)
             .json({mensaje:'Registro correcto'});
         }
     });

 };
exports.listar = function(req,res){
     usuario.find(function(err,resultado){
         if (err)
         {
             res.status(500).json({mensaje:'error con el listado'});
         }
         else
         {
             res.status(200).json(resultado);
         }
     });
 };