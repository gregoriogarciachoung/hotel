 var tarjeta = require('../models/tarjetas');
 
exports.listar = function(req,res){
     tarjeta.find(function(err,resultado){
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
 
 exports.agregar = function(req,res){
     var miTarj = new tarjeta();
     miTarj.numero = req.body.numero;
     miTarj.saldo = req.body.saldo;
	 miTarj.clave = req.body.clave;
     miTarj.save(function(err,resultado){
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
 
 exports.saldoXTarj = function(req,res){
	var num = req.body.numero;
	
     tarjeta.find({"numero":num},function(err,resultado){
         if (err)
         {
             res.status(500)
             .json({mensaje:'Error con el registro'})
         }
         else
         {
             res.status(200)
             .json({mensaje:resultado});
         }
     });

 };
 
 exports.actualizarSaldo = function(req,res){
	 //se actualiza con el valor 
		// en swift
		// obtener el saldo de la tarjeta (saldo actual)
		// en el formulario transacción sumar el saldo actual con el valor de la caja "saldo a recargar"
		// con el resultado obtenido se debe actualizarClave
	//ejemplo
	//saldo actual = 3
	//saldo que quiero recargar = 30
	//suma = saldo actual + saldo que quiero recargar
	//con el valor de la suma se debe actualizar.
     tarjeta.update({numero:req.body.numero},{$set:{saldo:req.body.saldo}},function(err,resultado){
         if (err)
         {
             res.status(500)
             .json({mensaje:'Error con el registro'})
         }
         else
         {
             res.status(200)
             .json({mensaje:"Transacción realizada"
			 });
         }
     });

 };