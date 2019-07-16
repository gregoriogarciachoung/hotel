 var mysql = require('mysql');
 //conector mysql
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "hotel"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected mysql!");
});

//cliente
 //mostrar las habitaciones que no están en una reserva (busca por fechas en la que se quiere reservar)
 exports.buscaHabitaciones = function(req,res){
     con.query('call ps_listarHabitacionesPorReserva(?,?)',[req.params.desde,req.params.hasta],(err, result) => {
      res.status(200).json(result);
     });
 };
 
 //crea una reserva(datos personales)
 exports.creaReserva = function(req,res){
     con.query('call sp_registraReserva(?,?,?,?)',[req.body.desde,req.body.hasta,req.body.dni,req.body.nombre],(err, result) => {
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
 
 //reserva una o varias habitaciones para la reserva creada
 exports.reservaHabitacion = function(req,res){
     con.query('call ps_reservarHabitacion(?,?,?,?,?)',[req.body.tipo,req.body.cantidad,req.body.pdni,req.body.desde,req.body.hasta],(err, result) => {
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

 exports.verReservaPorDni = function(req,res){
     con.query('call ps_verReservaPorDni(?)',[req.body.dni],(err, result) => {
      res.status(200).json(result);
     });
 };

  exports.listarHabitacionesPorReserva2 = function(req,res){
     con.query('call ps_listarHabitacionesPorReserva2(?)',[req.body.res],(err, result) => {
      res.status(200).json(result);
     });
 };

 // recepcionista

 exports.checkIn = function(req,res){
  con.query('call sp_checkIn(?)',[req.body.res],(err, result) => {
  res.status(200).json(result);
  });
 }

 exports.checkInDetalle = function(req,res){
  con.query('call sp_checkInDetalle(?,?,?)',[req.body.hab,req.body.des,req.body.res],(err, result) => {
  res.status(200).json(result);
  });
 }

  exports.checkInn = function(req,res){
  con.query('call sp_procesarAhora(?)',[req.body.res],(err, result) => {
  res.status(200).json(result);
  });
 }

 // servicio a habitación

 exports.consultarHospedajePorHabitacion = function(req,res){
     con.query('call ps_consultarHospedajePorHabitacion(?)',[req.body.hab],(err, result) => {
      res.status(200).json(result);
     });
 };

 exports.listaServicios = function(req,res){
  con.query('select * from serviciohabitacion',(err, result) => {
    //console.log(result);
      if (err)
         {
             res.status(500).json({mensaje:'error con el listado'});
         }
         else
         {
             res.status(200).json(result);
         }
  });
};

exports.servicioHabitacion = function(req,res){
  //console.log("ar");
  con.query('call ps_insertaServicioALaHabitacion(?,?,?,?)',[req.body.ser,req.body.can,req.body.hab,req.body.res],(err, result) => {
  res.status(200).json(result);
  });
 }

 // check out

 exports.listaServiciosConsumidos = function(req,res){
  con.query('select dsh.cantidad, sh.precio, sh.nombre, dsh.habitacion from detalleserviciohabitacion dsh join reserva r on dsh.reserva = r.codigo join serviciohabitacion sh on dsh.servicio = sh.id where r.codigo = ?',[req.body.res], (err, result) => {
    //console.log(result);
      if (err)
         {
             res.status(500).json({mensaje:'error con el listado'});
         }
         else
         {
             res.status(200).json(result);
         }
  });
};