import 'package:flutter/material.dart';

Color getColor(String tipo){
  if(tipo == "Acqua"){
    return Colors.blue;
  }
  else if(tipo == "Acciaio"){
    return Color(0xFF537D90);
  }
  else if(tipo == "Coleottero"){
    return Colors.green;
  }
  else if(tipo=="Drago"){
    return Color(0xFF0000E7);
  }
  else if(tipo =="Elettro"){
    return Colors.yellow;
  }
  else if(tipo== "Erba"){
    return Colors.lightGreen;
  }
  else if(tipo=="Folletto"){
    return Color(0xFFFFDBE9);
  }
  else if(tipo=="Fuoco"){
    return Color(0xFFff7000);
  }
  else if(tipo == "Ghiaccio"){
    return Colors.lightBlue;
  }
  else if(tipo=="Lotta"){
    return Color(0xFFb0331f);
  }
  else if(tipo=="Normale"){
    return Colors.grey;
  }
  else if(tipo=="Psico"){
    return Colors.pinkAccent;
  }
  else if(tipo=="Roccia"){
    return Color(0xFF7f7053);
  }
  else if(tipo == "Spettro") {
    return Color(0xFF570861);
  }
  else if(tipo== "Terra"){
    return Color(0xFFFFBF2E);
  }
  else if(tipo == "Volante") {
    return Color(0xFFA2CADF);
  }
  else if(tipo=="Veleno") {
    return Colors.purple;
  }
  else{
    return Colors.black;
  }

}