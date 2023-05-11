import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokedex/extensions/string_extension.dart';

class ModificaStats extends StatelessWidget {
  final collectionReference = FirebaseFirestore.instance.collection('pokemon');

  Future<void> aggiungiStats() async {
    String? pokemonName;
    // Esegui la chiamata API per ottenere la lista di tutti i Pokemon
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    if (response.statusCode == 200) {
      final pokemonList = json.decode(response.body)['results'];
      final startingIndex = 1; // escludi il primo pokemon
      final pokemonSublist = pokemonList.sublist(startingIndex);
      // Per ogni Pokemon, esegui una chiamata API per ottenere le sue statistiche base
      for (final pokemon in pokemonSublist) {
        pokemonName = pokemon['name'];
        final pokemonResponse = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));
        pokemonName = pokemonName?.capitalize();
        if (pokemonResponse.statusCode == 200) {
          final pokemonStats = json.decode(pokemonResponse.body)['stats'];
          // Estrai le statistiche di interesse
          final ps = pokemonStats[5]['base_stat'];
          final attSp = pokemonStats[4]['base_stat'];
          final attacco = pokemonStats[1]['base_stat'];
          final difSp = pokemonStats[3]['base_stat'];
          final difesa = pokemonStats[2]['base_stat'];
          final vel = pokemonStats[0]['base_stat'];
          final totale = ps + attSp + attacco + difSp + difesa + vel;
          // Aggiungi le statistiche alla collezione Firestore
          print('Aggiungendo statistiche per $pokemonName');
          final pokemonQuerySnapshot = await FirebaseFirestore.instance.collection('pokemon').where('Nome', isEqualTo: pokemonName).get();
          if (pokemonQuerySnapshot.docs.isNotEmpty) {
            final pokemonSnapshot = pokemonQuerySnapshot.docs.first;
            print('Document found: ${pokemonSnapshot.id}');
            final pokemonRef = pokemonSnapshot.reference;
            print('Document reference: $pokemonRef');
            print('Setting stats for $pokemonName...');
            await pokemonSnapshot.reference.update({
              'PS': ps,
              'AttSp': attSp,
              'Attacco': attacco,
              'DifSp': difSp,
              'Difesa': difesa,
              'Vel': vel,
              'Totale': totale,
            }).then((value) {
              print('Aggiornamento completato con successo per $pokemonName');
            }).catchError((error) {
              print('Si è verificato un errore durante l\'aggiornamento del documento per $pokemonName: $error');
            });
          }
        }
      }
    } else {
      print('Si è verificato un errore durante la chiamata API per ottenere la lista di Pokemon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi statistiche in collezione'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: aggiungiStats,
          child: Text('Aggiungi statistiche'),
        ),
      ),
    );
  }
}