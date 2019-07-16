 var cuenta = require('../models/cuentas');
 
exports.agregar = function(req,res){
     var miC = new cuenta();
     miC.numero = req.body.numero;
     miC.saldo = req.body.saldo;
	 miC.clave = req.body.clave;
     miC.save(function(err,resultado){
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
     cuenta.find(function(err,resultado){
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
 
 
 
  /*
 lo mismo se puede hace en swift
 meto ya no va.
  router.route('/cuantoVoyAObtener')
 .post(function(req,res){
	 var monto = parseInt(req.body.monto);
	 
	// var miCuenta = new cuenta();
	
	 
//	 var ncsaldo = parseInt(miCuenta.saldo) - monto;
	// var ntsaldo = parseInt(miTarjeta.saldo) + monto;
	  
	  var miT = new tarjeta();
	  
	tarjeta.find({numero:req.body.numt},function(err,resultado){
         if (err)
         {
             res.status(500)
             .json({mensaje:'Error con el registro'})
         }
         else
         {
            var ss = {"s":resultado};
			 
			 var s = ss.s;
			 var arr_s = s[0].saldo;
			 
			 nv = arr_s + monto;
			 
			 res.status(200).json({"saldo_actual":arr_s,"puedo_obtener":nv});
			 
         }
	});
 });
 */