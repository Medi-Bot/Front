import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medibot/request_page.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';
import 'package:medibot/models/date_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});

  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _civilities = ['Civilité', 'Monsieur', 'Madame'];
  String _civility = '';
  DateModel _birthDate = DateModel.fromTimestamp(DateTime.now().toString());
  int _weight = 0;
  int _height = 0;
  double _imc = 0;
  String _medicalHistory = '';

  void updateWeight(int weight) {
    setState(() {
      _weight = weight;
    });
    print(_weight);
    updateImc();
  }

  void updateHeight(int height) {
    setState(() {
      _height = height;
    });
    print(_height);
    updateImc();
  }

  void updateImc() {
    print('Updating...');
    if (_weight > 0 && _height > 0) {
      setState(() {
        double height = _height / 100;
        print('Height: ' + height.toString());
        _imc = _weight / (height * height);
      });
    } else {
      setState(() {
        _imc = 0;
      });
    }
    print(_imc);
  }

  void sendData() {
    if (_formKey.currentState!.validate()) {
      print('Envoyer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MediBotColors.white,
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
                child: const Image(
                    image: AssetImage('assets/images/logo/logo.png')),
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RequestPage(username: widget.username))),
                child: const Image(
                    image: AssetImage('assets/images/logo/chatbot.png')),
              ),
            ],
          )
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(
                              width: 70,
                              height: 70,
                              padding: const EdgeInsets.all(2.0), // borde width
                              decoration: const BoxDecoration(
                                color: Colors.grey, // border color
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Civilité',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width * 0.8,
                              initialSelection: _civilities.first,
                              onSelected: (String? value) {
                                if (value != null && !value.isEmpty) {
                                  _civility = value;
                                  print(_civility);
                                } else {
                                  _civility = '';
                                }
                              },
                              dropdownMenuEntries: _civilities
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                    value: value, label: value);
                              }).toList(),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Date de naissance',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  filled: true,
                                ),
                                initialValue: _birthDate.toString(),
                                onChanged: (value) =>
                                    updateWeight(int.parse(value)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pas de texte';
                                  } else {
                                    List<String> cutedValue = value.split("/");
                                    if (cutedValue.length != 3) {
                                      return 'Date non valide';
                                    }
                                    _birthDate.day = int.parse(cutedValue[0]);
                                    _birthDate.month = int.parse(cutedValue[1]);
                                    _birthDate.year = int.parse(cutedValue[2]);
                                  }
                                }),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Poids (en kg)',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                initialValue: _weight.toString(),
                                onChanged: (value) =>
                                    updateWeight(int.parse(value)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pas de texte';
                                  } else if (int.tryParse(value) == null ||
                                      value.length < 4) {
                                    return 'Veuillez entrer un nombre valide';
                                  } else {
                                    updateWeight(int.parse(value));
                                  }
                                }),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Taille (en cm)',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                initialValue: _height.toString(),
                                onChanged: (value) =>
                                    updateHeight(int.parse(value)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pas de texte';
                                  } else if (double.tryParse(value) == null ||
                                      value.length < 3) {
                                    return 'Veuillez entrer un nombre valide';
                                  } else {
                                    updateHeight(int.parse(value));
                                  }
                                }),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'IMC',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                filled: true,
                              ),
                              key: Key(_imc.toStringAsFixed(2)),
                              initialValue: _imc.toStringAsFixed(2),
                              enabled: false,
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Médicaments',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Antécédents médicaux',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pas de texte';
                                  } else {
                                    _medicalHistory = value;
                                    print(_medicalHistory);
                                  }
                                }),
                            SizedBox(
                              height: 75,
                            )
                          ]))))),
      floatingActionButton: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MediBotColors.color3)),
          onPressed: () => sendData(),
          child: const Text(
            'Envoyer',
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
