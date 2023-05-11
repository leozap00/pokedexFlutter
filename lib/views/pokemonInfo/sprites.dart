import 'package:flutter/material.dart';

Widget getSprite(String selectedValue, Map<String, dynamic> data){
  String? sprite;
  final List<dynamic> sprites = data['sprite'];
  int index = 0;
  switch(selectedValue){
    case 'Rosso/Blu/Verde':
      index = 0;
      break;
    case 'Giallo':
      index = 1;
      break;
    case 'Oro':
      index = 2;
      break;
    case 'Argento':
      index = 3;
      break;
    case 'Cristallo':
      index = 4;
      break;
    case 'Rubino':
      index = 5;
      break;
    case 'Zaffiro':
      index = 6;
      break;
    case 'Smeraldo':
      index = 7;
      break;
    case 'Rosso Fuoco':
      index = 8;
      break;
    case 'Verde Foglia':
      index = 9;
      break;
    case 'Diamante':
      index = 10;
      break;
    case 'Perla':
      index = 11;
      break;
    case 'Platino':
      index = 12;
      break;
    case 'HeartGold':
      index = 13;
      break;
    case 'SoulSilver':
      index = 14;
      break;
    case 'Nero':
      index = 15;
      break;
    case 'Bianco':
      index = 16;
      break;
    case 'Nero2':
      index = 17;
      break;
    case 'Bianco2':
      index = 18;
      break;
    case 'X':
      index = 19;
      break;
    case 'Y':
      index = 20;
      break;
    case 'Rubino Omega':
      index = 21;
      break;
    case 'Zaffiro Alpha':
      index = 22;
      break;
    case 'Sole':
      index = 23;
      break;
    case 'Luna':
      index = 24;
      break;
    case 'Ultrasole':
      index = 25;
      break;
    case 'Ultraluna':
      index = 26;
      break;
    case "Let's Go, Pikachu!/Let's Go,Eevee!":
      index = 27;
      break;
    case 'Spada':
      index = 28;
      break;
    case 'Scudo':
      index = 29;
      break;
    case 'Diamante Lucente':
      index = 30;
      break;
    case 'Perla Splendente':
      index = 31;
      break;
    case 'Pokémon GO':
      index = 32;
      break;
    case 'Leggende Arceus':
      index = 33;
      break;
    case 'Scarlatto':
      index = 34;
      break;
    case 'Violetto':
      index = 35;
      break;

    default:
      sprite = null;
      break;
  }
  if (index < sprites.length) {
    sprite = sprites[index];
  } else {
    sprite = "Non disponibile";
  }
  return sprite != "Non disponibile" ?
    Image.network(sprite!):
  const Text("Non disponibile");

}