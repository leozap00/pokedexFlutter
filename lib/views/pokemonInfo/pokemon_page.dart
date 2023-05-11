import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokedex/constants/colors.dart';
import 'package:pokedex/views/pokemonInfo/sprites.dart';

import 'descriptions.dart';

const List<String> list = <String>[
  'Rosso/Blu/Verde',
  'Giallo',
  'Oro',
  'Argento',
  'Cristallo',
  'Rubino',
  'Zaffiro',
  'Smeraldo',
  'Rosso Fuoco',
  'Verde Foglia',
  'Diamante',
  'Perla',
  'Platino',
  'HeartGold',
  'SoulSilver',
  'Nero',
  'Bianco',
  'Nero2',
  'Bianco2',
  'X',
  'Y',
  'Rubino Omega',
  'Zaffiro Alpha',
  'Sole',
  'Luna',
  'Ultrasole',
  'Ultraluna',
  "Let's Go, Pikachu!/Let's Go,Eevee!",
  'Spada',
  'Scudo',
  'Diamante Lucente',
  'Perla Splendente',
  'Pokémon GO',
  'Leggende Arceus',
  'Scarlatto',
  'Violetto'
];

class PokemonPage extends StatefulWidget {
  final String id;

  const PokemonPage({Key? key, required this.id}) : super(key: key);

  @override
  _PokemonPageState createState() => _PokemonPageState(id);
}

class _PokemonPageState extends State<PokemonPage> {
  final String id;

  _PokemonPageState(this.id);

  String _selectedValue = list.first;

  void _onDropdownValueChanged(String newValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedValue = newValue;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedValue = list.first;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('pokemon').doc(id).snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.hasData) {
          final data = snapshot.data!.data()!;
          Widget descriptionWidget = getDescription(_selectedValue, data);
          Widget spriteWidget = getSprite(_selectedValue, data);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: getColor(data['Tipo']),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['num'],
                                        style: const TextStyle(fontSize: 26)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(data['Nome'],
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        const Text("Categoria: ",
                                            style: TextStyle(fontSize: 18)),
                                        Text(data['categoria'],
                                            style:
                                                const TextStyle(fontSize: 18))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              color: getColor(data["Tipo"]),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: Text(data["Tipo"],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white))),
                                        const SizedBox(width: 5),
                                        data['Tipo2'] != ""
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      getColor(data["Tipo2"]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                child: Text(data["Tipo2"],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white)))
                                            : const SizedBox.shrink(),
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Image.network(data['image'])
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text("Altezza",
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(height: 5),
                                    Text(data['altezza'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("Peso",
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(data['peso'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text("Abilità",
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(height: 5),
                                    Text(data['abilità'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    data['abilità2'] != null
                                        ? Text(data['abilità2'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))
                                        : const SizedBox.shrink()
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("Abilità speciale",
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(height: 5),
                                    Text(data['abilitàsp'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 15),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Descrizione",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                DropdownButtonVers(
                                  snapshot: snapshot,
                                  onValueChanged: _onDropdownValueChanged,
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            descriptionWidget,
                            const SizedBox(height: 25),
                            const Text(
                              "Sprite",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 21),
                            ),
                            const SizedBox(height: 15),
                            spriteWidget,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Statistiche di base",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 21),
                              ),
                            ),
                            const SizedBox(height: 15),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 50,
                              lineHeight: 21.0,
                              percent: double.parse(data["PS"].toString()) / 255,
                              center: Text(
                                "PS: ${data['PS'].toString()} ",
                                style: TextStyle(fontSize: 10),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.greenAccent,
                            ),
                            const SizedBox(height: 5),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 50,
                              lineHeight: 21,
                              percent: double.parse(data["Attacco"].toString()) / 255,
                              center: Text(
                                "Attacco: ${data['Attacco'].toString()}",
                                style: TextStyle(fontSize: 10),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.orange,
                            ),
                            const SizedBox(height: 5),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 50,
                              lineHeight: 21.0,
                              percent: double.parse(data["Difesa"].toString()) / 255,
                              center: Text(
                                "Difesa: ${data["Difesa"].toString()}",
                                style: TextStyle(fontSize: 10),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.orangeAccent,
                            ),
                            const SizedBox(height: 5),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 50,
                              lineHeight: 21.0,
                              percent: double.parse(data["AttSp"].toString()) / 255,
                              center: Text(
                                "Att. Sp.: ${data["AttSp"].toString()}",
                                style: TextStyle(fontSize: 10),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.lightBlueAccent,
                            ),
                            const SizedBox(height: 5),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 50,
                              lineHeight: 21.0,
                              percent: double.parse(data["DifSp"].toString()) / 255,
                              center: Text(
                                "Dif. Sp.: ${data["DifSp"].toString()}",
                                style: TextStyle(fontSize: 10),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.blue,
                            ),
                            const SizedBox(height: 5),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 50,
                              lineHeight: 21.0,
                              percent: double.parse(data["Vel"].toString()) / 255,
                              center: Text(
                                "Velocità: ${data["Vel"].toString()}",
                                style: TextStyle(fontSize: 10),
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.purple,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text("Totale:"),
                                const SizedBox(width: 6),
                                Text(data["Totale"].toString())
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}

class DropdownButtonVers extends StatefulWidget {
  final Function(String) onValueChanged;
  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot;

  const DropdownButtonVers({
    required this.onValueChanged,
    required this.snapshot,
    Key? key,
  }) : super(key: key);

  @override
  State<DropdownButtonVers> createState() => _DropdownButtonVersState();
}

class _DropdownButtonVersState extends State<DropdownButtonVers> {
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    widget.onValueChanged(dropdownValue);
  }

  String get selectedValue => dropdownValue;

  @override
  Widget build(BuildContext context) {
    final descriptions = getDescriptionList(widget.snapshot.data!.data()!);

    final filteredItems = list
        .where((value) {
      final descriptionIndex = getIndexForValue(value);
      return descriptionIndex != null &&
          descriptionIndex < descriptions.length &&
          descriptions[descriptionIndex] != "Non disponibile";
    })
        .map((value) =>
        DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        ))
        .toList();

    return Expanded(
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
          widget.onValueChanged(value!);
        },
        items: filteredItems,
      ),
    );
  }

  int? getIndexForValue(String value) {
    final data = widget.snapshot.data?.data();
    final descriptions = data?['descrizioni'] as List<dynamic>?;

    if (descriptions != null && descriptions is List<String>) {
      return descriptions.indexOf(value);
    }

    return null;
  }
  List<String> getDescriptionList(Map<String, dynamic> data) {
    final descriptions = data['descrizioni'] as List<dynamic>?;

    if (descriptions != null && descriptions is List<String>) {
      return descriptions;
    }

    return [];
  }

}