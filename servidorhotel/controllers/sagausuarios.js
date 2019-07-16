 var mysql = require('mysql');
 //conector mysql
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "caja"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected mysql!");
});

var usuario = require('../models/sagausuarios');

exports.agregar = function(req,res){

     con.query('call sp_regUsuario(?,?,?,?,?)',[req.body.nombre,req.body.correo,req.body.dni,req.body.usu,req.body.pass],(err, result) => {
      res.status(500).json({mensaje:':)'});
     });

 };
 
exports.listar = function(req,res){
  con.query('select * from usuarios',(err, result) => {
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

exports.login = function(req,res){

     con.query('select count(*) as valida from usuarios where usu = ? and pass = ?',[req.body.usu,req.body.pass],(err, result) => {
      res.status(200).json(result);
     });
 };
exports.login2 = function(req,res){

     con.query('call sp_login(?,?)',[req.body.usu,req.body.pass],(err, result) => {
      res.status(200).json(result);
     });
 };