import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//import package file manually

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
         theme: ThemeData(
            primarySwatch:Colors.blueGrey //primary color for theme
         ),
         home: WriteSQLdata() //set the class here
    );
  }
}


class WriteSQLdata extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return WriteSQLdataState();
  }
}

class WriteSQLdataState extends State<WriteSQLdata>{

  TextEditingController namectl = TextEditingController();
  TextEditingController addressctl = TextEditingController();
  TextEditingController classctl = TextEditingController();
  TextEditingController rollnoctl = TextEditingController();
  //text controller for TextField

  late bool error, sending, success;
  late String msg;

  String phpurl = "http://192.168.0.33/test/write.php";
  // do not use http://localhost/ for your local
  // machine, Android emulation do not recognize localhost
  // insted use your local ip address or your live URL
  // hit "ipconfig" on Windows or  "ip a" on Linux to get IP Address

  @override
  void initState() {
      error = false;
      sending = false;
      success = false;
      msg = "";
      super.initState();
  }

  Future<void> sendData() async {

     var res = await http.post(Uri.parse(phpurl), body: { 
          "cpf": namectl.text,
          "nome": addressctl.text,
          "email": classctl.text,
          "senha": rollnoctl.text,
      }); //sending post request with header data

     if (res.statusCode == 200) {
       print(res.body); //print raw response on console
       var data = json.decode(res.body); //decoding json to array
       if(data["error"]){
          setState(() { //refresh the UI when error is recieved from server
             sending = false;
             error = true;
             msg = data["message"]; //error message from server
             
          });
       }else{
         
         namectl.text = "";
         addressctl.text = "";
         classctl.text = "";
         rollnoctl.text = "";
         //after write success, make fields empty

          setState(() {
             sending = false;
             success = true; //mark success and refresh UI with setState
          });
       }
       
    }else{
       //there is error
        setState(() {
            error = true;
            msg = "Error during sendign data.";
            sending = false;
            //mark error and refresh UI with setState
        });
    }
  }
  

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title:Text("Criar Cadastro"),
           backgroundColor:Color.fromARGB(238, 112, 208, 252)
        ), //appbar

        body: SingleChildScrollView( //enable scrolling, when keyboard appears,
                                   // hight becomes small, so prevent overflow
           child:Container( 
              padding: EdgeInsets.all(20),
              
              child: Column(
                
                children: <Widget>[
                
                Container( 
                  child:Text(
                    error?msg:"Cadastre-se ",
                       style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)), 
                  //if there is error then sho msg, other wise show text message
                ),
                SizedBox(
                  height: 10,
                ),
                Container( 
                   child:Text(
                     success?"Cadastro efetuado !":"Insira os dados abaixo:",
                      style: TextStyle(
                        fontSize: 30),
                     ),
                   //is there is success then show "Write Success" else show "send data"
                ),
              SizedBox(
                  height: 80,
                ),
                Container( 
                  height: 30,
                  
                  
                  child: TextField( 
                      
                      style: TextStyle(height: 1.5),
                     controller: namectl,
                     decoration: InputDecoration(
                       
                       contentPadding: EdgeInsets.all(10.0),
                        labelText:"CPF:",
                        
                        hintText:"Insira seu CPF",
                        filled: true,
                        fillColor: Color.fromARGB(238, 112, 208, 252),
                        border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                     ),
                  )
                ), //text input for name
              SizedBox(
                  height: 10,
                ),
                Container( 
                  height: 30, 
                  child: TextField( 
                     controller: addressctl,
                     decoration: InputDecoration(  
                       contentPadding: EdgeInsets.all(10.0),                     
                        labelText:"Nome:",
                        hintText:"Insira seu nome compketo",
                        filled: true,
                        fillColor: Color.fromARGB(238, 112, 208, 252),
                        border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                        
                     ),
                  )
                ), //text input for address
               SizedBox(
                  height: 10,
                ),
                Container( 
                  height: 30, 
                  child: TextField(
                     controller: classctl,
                     decoration: InputDecoration(
                       contentPadding: EdgeInsets.all(10.0),
                        labelText:"Email:",
                        hintText:"insira seu email",
                        filled: true,
                        fillColor: Color.fromARGB(238, 112, 208, 252),
                        border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                     ),
                  )
                ), //text input for class
              SizedBox(
                  height: 10,
                ),

                Container( 
                  height: 30, 
                  child: TextField( 
                    obscureText: true,
                     controller: rollnoctl,
                     decoration: InputDecoration(
                       contentPadding: EdgeInsets.all(10.0),
                        labelText:"Senha:",
                        hintText:"Insira sua senha",
                        filled: true,
                        fillColor: Color.fromARGB(238, 112, 208, 252),
                        border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                     ),
                  )
                ), //text input for roll no

                Container( 
                  width: 90,
                  height: 40,
                   margin: EdgeInsets.only(top:20),
                   child:SizedBox( 
                     width: double.infinity,
                     child:RaisedButton(
                       
                        onPressed:(){
                           showAlertDialog(context);
                                          
                          setState(() { //if button is pressed, setstate sending = true, so that we can show "sending..."
                             sending = true;
                          });
                          sendData();
                          
                        },
                        
                        child: Text(
                          
                          sending?"Enviando...":"Cadastrar",
                          //if sending == true then show "Sending" else show "SEND DATA";
                        style: TextStyle(
                          color: Color.fromARGB(255, 80, 78, 78),
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                        color: Color.fromARGB(255, 82, 255, 160),
                        colorBrightness: Brightness.dark,
                        //background of button is darker color, so set brightness to dark
                     )
                   )
                )
              ],)
           )
        ),
     );
  }
}

showAlertDialog(BuildContext context) {  
  // Create button  
  Widget okButton = FlatButton(  
    child: Text("OK"),  
    onPressed: () {  
      Navigator.of(context).pop();  
    },  
  );  
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text(""),  
    content: Text("This is an alert message."),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  

