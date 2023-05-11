import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/services/add_descr.dart';
import 'package:pokedex/services/add_sprite.dart';
import 'package:pokedex/services/add_stats.dart';
import 'package:pokedex/views/pokemonInfo/pokemon_page.dart';
import 'dart:math' as math;
import 'package:pokedex/extensions/string_extension.dart';

import '../constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = "";
  CollectionReference poke = FirebaseFirestore.instance.collection('pokemon');

  @override
  void initState() {
    super.initState();
  }

  void callPokeScreen(BuildContext context, String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PokemonPage(id: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(180.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black, size: 35),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pokédex",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: SizedBox(
                          width: 300,
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                query = val.capitalize();
                              });
                            },
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                hintText: 'Cerca...',
                                hintStyle:
                                    const TextStyle(color: Colors.grey, fontSize: 18),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 18,
                                  child: const Icon(Icons.search),
                                )),
                          )),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Modifiche in Firestore',
                    style: TextStyle(fontSize: 36),
                  )),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Modifica descrizioni'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModificaDescrizioni()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Modifica Statistiche'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModificaStats()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Modifica Sprites'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ModificaSprites()));
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: (query.isNotEmpty)
                ? poke
                    .orderBy('Nome')
                    .where('Nome', isGreaterThanOrEqualTo: query)
                    .where('Nome', isLessThanOrEqualTo: query + '\uf8ff')
                    .snapshots()
                : poke.orderBy('num').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }

              if (snapshot.hasData) {
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final name = doc['Nome'].toString().capitalize();
                  return name.startsWith(query);
                }).toList();
                return SafeArea(
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: filteredDocs.length,
                      //snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = filteredDocs[index];
                        return GestureDetector(
                          onTap: () => callPokeScreen(context, data['id']),
                          child: Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            decoration: BoxDecoration(
                              color:
                                  getColor(snapshot.data?.docs[index]['Tipo']),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          snapshot.data?.docs[index]['Nome'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF606060),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: Text(
                                                snapshot.data?.docs[index]
                                                    ['Tipo'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white))),
                                        const SizedBox(width: 5),
                                        data['Tipo2'] != ""
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF606060),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                child: Text(
                                                    snapshot.data?.docs[index]
                                                        ['Tipo2'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white)))
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Stack(children: [
                                      Transform.rotate(
                                          angle: -math.pi / 4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, right: 0),
                                            child: Image.asset(
                                              "assets/images/pokeball.png",
                                              opacity:
                                                  const AlwaysStoppedAnimation(
                                                      .5),
                                            ),
                                          )),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Image.network(
                                              snapshot.data?.docs[index]
                                                  ['image'],
                                              height: 100,
                                              width: 100)),
                                    ])),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
              return Container();
            }));
  }
}
