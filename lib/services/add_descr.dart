import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModificaDescrizioni extends StatelessWidget {
  final collectionReference = FirebaseFirestore.instance.collection('pokemon');

// Leggi il file JSON contenente le descrizioni del pokedex
  Future<String> readJsonFile(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    print('JSON string: $jsonString');
    return jsonString;
  }

  Future<void> aggiungiDescrizioni() async {
    // Carica il file JSON
    final jsonString = await readJsonFile("assets/json/pokemon_desc.json");
    print("JSON String aggiornaDesc: $jsonString");
    // Converte il JSON in una mappa
    final Map<String, String> descrizioni = json.decode(jsonString).cast<String, String>();

    // Itera su tutte le descrizioni
    for (final nome in descrizioni.keys) {
      final pokemonQuerySnapshot =
      await FirebaseFirestore.instance.collection('pokemon').where('Nome', isEqualTo: nome).get();
      if (pokemonQuerySnapshot.docs.isNotEmpty) {
        // Aggiorna il documento esistente
        final pokemonSnapshot = pokemonQuerySnapshot.docs.first;
        final data = pokemonSnapshot.data();
        final descrizioniArray = data['descrizioni'] != null ? List<dynamic>.from(data['descrizioni']) : [];
        descrizioniArray[5] = descrizioni[nome];
        await pokemonSnapshot.reference.update({'descrizioni': descrizioniArray})
            .then((value) {
          print('Aggiornamento completato con successo');
        })
            .catchError((error) {
          print('Si è verificato un errore durante l\'aggiornamento del documento: $error');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi descrizioni in collezione'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: aggiungiDescrizioni,
          child: Text('Aggiungi descrizioni'),
        ),
      ),
    );
  }
}