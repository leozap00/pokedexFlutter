import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class ModificaSprites extends StatelessWidget {
  final collectionReference = FirebaseFirestore.instance.collection('pokemon');

// Leggi il file JSON contenente le descrizioni del pokedex
  Future<String> readJsonFile(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    print('JSON string: $jsonString');
    return jsonString;
  }
  Future<void> aggiungiSprites() async {
    // Carica il file JSON
    final jsonString = await readJsonFile("assets/json/pokemon_sprites_16.json");
    print("JSON String aggiornaDesc: $jsonString");
    // Converte il JSON in una mappa
    final Map<String, String> sprites = json.decode(jsonString).cast<String, String>();

    // Itera su tutte le descrizioni
    for (final nome in sprites.keys) {
      final pokemonQuerySnapshot =
      await FirebaseFirestore.instance.collection('pokemon').where('Nome', isEqualTo: nome).get();
      if (pokemonQuerySnapshot.docs.isNotEmpty) {
        // Aggiorna il documento esistente
        final pokemonSnapshot = pokemonQuerySnapshot.docs.first;
        final data = pokemonSnapshot.data();
        final spritesArray = data['sprite'] != null ? List<dynamic>.from(data['sprite']) : [];
        // Verifica se il campo sprite esiste già
        if (spritesArray.isEmpty) {
          // Aggiungi il campo sprite
          spritesArray.add(sprites[nome]);
          await pokemonSnapshot.reference.update({'sprite': spritesArray})
              .then((value) {
            print('Aggiornamento completato con successo');
          })
              .catchError((error) {
            print('Si è verificato un errore durante l\'aggiornamento del documento: $error');
          });
        } else {
          // Aggiorna il valore del campo sprite
          //spritesArray.insert(34, sprites[nome]);
          //spritesArray.insert(35, sprites[nome]);
          spritesArray[30] = sprites[nome];
          spritesArray[31] = sprites[nome];
          await pokemonSnapshot.reference.update({'sprite': spritesArray})
              .then((value) {
            print('Aggiornamento completato con successo');
          })
              .catchError((error) {
            print(
                'Si è verificato un errore durante l\'aggiornamento del documento: $error');
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi sprite in Firestore'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: aggiungiSprites,
          child: Text('Aggiungi sprite'),
        ),
      ),
    );
  }
}