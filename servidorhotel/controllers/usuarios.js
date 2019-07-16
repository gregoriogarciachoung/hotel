 var usuario = require('../models/usuarios');
exports.agregar = function(req,res){
	 var cla = req.body.clave;
     var miUsuario = new usuario();
     miUsuario.correo = req.body.correo;
     miUsuario.clave = cla;
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
 
 exports.login1 = function(req,res){
	 //usuario.find({"clave":cla}).exec(function(err,resultado){
	//usuario.find({"clave":cla},function(err,resultado){
	 var cla = req.body.clave;
	 var usu = req.body.correo;
	 usuario.find({correo:usu, clave:cla},function(err,resultado){
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
 
 exports.login2 = function(req,res){
	 //usuario.find({"clave":cla}).exec(function(err,resultado){
	//usuario.find({"clave":cla},function(err,resultado){
	 var cla = req.body.clave;
	 var usu = req.body.correo;
	 usuario.find({correo:usu, clave:cla},function(err,resultado){
		 if (err)
         {
             res.status(500).json({mensaje:'error con el listado'});
         }
         else
         {
			 if(resultado == ""){
				  res.status(200).json({"valida":"0"});	
			 }else{
				 res.status(200).json({"valida":"1"});				 
			 }

         }
	 });
 };
  exports.actualizarClave = function(req,res){
     usuario.update({correo:req.body.correo},{$set:{clave:req.body.clave}},function(err,resultado){
         if (err)
         {
             res.status(500)
             .json({mensaje:'Error con el registro'})
         }
         else
         {
             res.status(200)
             .json({mensaje:'Actualizado'
			 });
         }
     });

 };
 