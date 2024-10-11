import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medibot/models/medicament_utilise.dart';
import 'package:medibot/models/treatment_model.dart';
import 'package:medibot/request_page.dart';
import 'package:medibot/services/main_service.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';
import 'package:medibot/models/date_model.dart';

import 'models/all_data_dto.dart';
import 'models/antecedent.dart';
import 'models/poids.dart';
import 'models/taille.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});

  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _treatmentFormKey = GlobalKey<FormState>();
  final List<String> _civilities = ['Civilité', 'Monsieur', 'Madame'];
  String _civility = '';
  DateModel _birthDate = DateModel.fromTimestamp(DateTime.now().toString());
  double _weight = 0;
  double _height = 0;
  double _imc = 0;
  String _medicalHistory = '';
  String _tempTreatmentName = '';
  DateModel _tempTreatmentStartDate =
  DateModel.fromTimestamp(DateTime.now().toString());
  String _tempTreatmentFrequency = '';
  DateModel _tempTreatmentEndDate =
  DateModel.fromTimestamp(DateTime.now().toString());
  late Future<AllDataDto> data;
  MainService service = MainService();
  AllDataDto? allData = null;

  @override
  void initState() {
    data = service.getAll();
    super.initState();
  }

  void initWeightHeight(double weight, double height){
    if(_weight == 0 && _height == 0){
      _weight = weight;
      _height = height;
      _imc = _weight / (_height / 100 * _height / 100);
    }
  }

  void updateWeight(double weight) {
    setState(() {
      _weight = weight;
    });
    updateImc();
  }

  void updateHeight(double height) {
    setState(() {
      _height = height;
    });
    updateImc();
  }

  void updateImc() {
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
  }

  void sendData() async {
    if (_formKey.currentState!.validate()) {
      if(allData != null){
        String date = DateModel.fromTimestamp(DateTime.now().toString()).toTimestamp();
        allData!.getLastInformations().dateDeNaissance = _birthDate.toTimestamp();
        Future
            .wait([_weight != 0 ? service.addPoids(Poids(date, _weight)) : Future.delayed(Duration(milliseconds: 0)),
              _height != 0 ? service.addTaille(Taille(date, _height)) : Future.delayed(Duration(milliseconds: 0)),
              service.changeDateNaissance(allData!.getLastInformations()),
              _medicalHistory != "" ? service.addAntecedent(Antecedent(date, _medicalHistory)) : Future.delayed(Duration(milliseconds: 0))])
            .then((List responses) => {
              setState(() {
                data = service.getAll();
              })
            })
            .catchError((e) => false);

      }

    }
  }

  void addTreatment() async {
    if (_treatmentFormKey.currentState!.validate()) {
      await service.addMedicamentUtilise(MedicamentUtilise(_tempTreatmentStartDate.toTimestamp(), _tempTreatmentName, _tempTreatmentFrequency, _tempTreatmentEndDate.toTimestamp()));
      setState(() {
        _tempTreatmentName = '';
        _tempTreatmentStartDate =
            DateModel.fromTimestamp(DateTime.now().toString());
        _tempTreatmentFrequency = '';
        _tempTreatmentEndDate =
            DateModel.fromTimestamp(DateTime.now().toString());
        data = service.getAll();
      });
    }
  }

  Widget showMyTreatments() {
    List<Widget> rowList = [];
    if(allData != null){
      for (MedicamentUtilise medicament in allData!.medicamentUtilises) {
        rowList.add(Row(children: [
          Column(
            children: [
              Row(
                children: [Text('- ' + medicament.nom + ': ')],
              ),
              Row(
                children: [
                  Text('Du ' + DateModel.fromTimestamp(medicament.dateDebut).toString()),
                  Text(' au ' + DateModel.fromTimestamp(medicament.dateFin).toString())
                ],
              ),
              Row(
                children: [Text('Fréquence: ' + medicament.frequence)],
              )
            ],
          )
        ]));
      }
    }
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowList,
      ),
    );
  }

  Widget treatmentForm() {
    return Form(
        key: _treatmentFormKey,
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Nom du médicament',
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
              initialValue: _tempTreatmentName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pas de texte';
                } else {
                  _tempTreatmentName = value;
                  print(_tempTreatmentName);
                }
              }),
          Row(
            children: [
              Text(
                'Date de début',
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
              onChanged: (value) => updateWeight(double.parse(value)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pas de texte';
                } else {
                  List<String> cutedValue = value.split("/");
                  if (cutedValue.length != 3) {
                    return 'Date non valide';
                  }
                  _tempTreatmentStartDate.day = int.parse(cutedValue[0]);
                  _tempTreatmentStartDate.month = int.parse(cutedValue[1]);
                  _tempTreatmentStartDate.year = int.parse(cutedValue[2]);
                }
              }),
          Row(
            children: [
              Text(
                'Fréquence',
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
                  _tempTreatmentFrequency = value;
                  print(_tempTreatmentFrequency);
                }
              }),
          Row(
            children: [
              Text(
                'Date de fin',
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
              onChanged: (value) => updateWeight(double.parse(value)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pas de texte';
                } else {
                  List<String> cutedValue = value.split("/");
                  if (cutedValue.length != 3) {
                    return 'Date non valide';
                  }
                  _tempTreatmentEndDate.day = int.parse(cutedValue[0]);
                  _tempTreatmentEndDate.month = int.parse(cutedValue[1]);
                  _tempTreatmentEndDate.year = int.parse(cutedValue[2]);
                }
              }),
          SizedBox(height: 10),
          TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(MediBotColors.color3)),
              onPressed: () => addTreatment(),
              child: const Text(
                'Ajouter',
                style: TextStyle(fontSize: 20),
              )),
        ],
      ),
    ));
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
              child : FutureBuilder(
                future: data,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    AllDataDto dto = snapshot.data!;
                    allData = dto;
                    _birthDate = DateModel.fromTimestamp(dto.getLastInformations().dateDeNaissance);
                    initWeightHeight(dto.getLastPoids().poids, dto.getLastTaille().taille);
                    print(dto.getLastPoids().date);
                    print(DateModel.fromTimestamp(dto.getLastPoids().date));
                    print(DateModel.fromTimestamp(dto.getLastPoids().date).toString());
                    return Form(
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
                                          updateWeight(double.parse(value)),
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
                                  SizedBox(
                                    height: min(dto.poids.length * 20, 100) ,
                                    child: dto.poids.isNotEmpty ? ListView.builder(
                                      reverse: true,
                                      itemCount: dto.poids.length,
                                      itemBuilder: (context, index){
                                        index = dto.poids.length - index - 1;
                                        return Row(
                                          children: [
                                            Text(DateModel.fromTimestamp(dto.poids[index].date).toString()),
                                            Expanded(child: Container()),
                                            Text(dto.poids[index].poids.toString())
                                          ],
                                        );
                                      }
                                    ) : Container(),
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
                                      initialValue: dto.getLastPoids().poids.toString(),
                                      onChanged: (value) =>
                                          updateWeight(double.parse(value)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Pas de texte';
                                        } else {
                                          updateWeight(double.parse(value));
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
                                  SizedBox(
                                    height: min(dto.tailles.length * 20, 100),
                                    child: dto.tailles.isNotEmpty ? ListView.builder(
                                      reverse: true,
                                        itemCount: dto.tailles.length,
                                        itemBuilder: (context, index){
                                          index = dto.tailles.length - index - 1;
                                          return Row(
                                            children: [
                                              Text(DateModel.fromTimestamp(dto.tailles[index].date).toString()),
                                              Expanded(child: Container()),
                                              Text(dto.tailles[index].taille.toString())
                                            ],
                                          );
                                        }
                                    ) : Container(),
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
                                      initialValue: dto.getLastTaille().taille.toString(),
                                      onChanged: (value) =>
                                          updateHeight(double.parse(value)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Pas de texte';
                                        } else if (double.tryParse(value) == null ||
                                            value.length < 3) {
                                          return 'Veuillez entrer un nombre valide';
                                        } else {
                                          updateHeight(double.parse(value));
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
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Column(children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Mes traitements :',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      showMyTreatments(),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            'Ajouter un traitement',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      treatmentForm()
                                    ]),
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
                                  SizedBox(
                                    height: min(dto.antecedents.length * 20, 100),
                                    child: dto.antecedents.isNotEmpty ? ListView.builder(
                                      reverse: true,
                                      itemCount: dto.antecedents.length,
                                      itemBuilder: (context, index){
                                        index = dto.antecedents.length - index - 1;
                                        return Row(
                                          children: [
                                            Text(DateModel.fromTimestamp(dto.antecedents[index].date).toString()),
                                            Expanded(child: Container()),
                                            Text(dto.antecedents[index].description)
                                          ],
                                        );
                                      }
                                    ) : Container(),
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
                                        _medicalHistory = value ?? "";
                                        print(_medicalHistory);
                                      }),
                                  SizedBox(
                                    height: 75,
                                  )
                                ]
                            )
                        )
                    );
                  }
                  else if(snapshot.hasError){
                    return Text(snapshot.error!.toString());
                  }
                  return CircularProgressIndicator();
                }
              )
          )
      ),
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
