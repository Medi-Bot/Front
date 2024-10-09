import 'package:flutter/material.dart';
import 'package:medibot/request_page.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});

  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> civilities = ['Civilité', 'Monsieur', 'Madame'];
  String test = '';
  double weight = 0;
  double height = 0;
  double imc = 0;

  void updateImc() {
    setState(() {
      imc = weight / (height * height);
    });
  }

  Widget row1() {
    return Row(
      children: [
        Column(
          children: [
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
              initialSelection: civilities.first,
              onSelected: (String? value) {
                print(value);
              },
              dropdownMenuEntries:
                  civilities.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  'Date de naissance',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 5),
            InputDatePickerFormField(
                firstDate: new DateTime(2024), lastDate: new DateTime(2024)),
          ],
        ),
      ],
    );
  }

  Widget row2() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(
                  'Poids',
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
                validator: (login) {
                  if (login == null || login.isEmpty) {
                    return 'Pas de texte';
                  } else {
                    test = login;
                  }
                }),
          ],
        )
      ],
    );
  }

  Widget row3() {
    return Row();
  }

  Widget row4() {
    return Row(
      children: [
        Column(
          children: [
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
                validator: (login) {
                  if (login == null || login.isEmpty) {
                    return 'Pas de texte';
                  } else {
                    print('Test');
                  }
                }),
          ],
        ),
      ],
    );
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
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
                          initialSelection: civilities.first,
                          onSelected: (String? value) {
                            print(value);
                          },
                          dropdownMenuEntries:
                          civilities.map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(value: value, label: value);
                          }).toList(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Date de naissance',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        InputDatePickerFormField(
                            firstDate: new DateTime(2024), lastDate: new DateTime(2024)),
                        Row(
                          children: [
                            Text(
                              'Poids',
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
                            validator: (login) {
                              if (login == null || login.isEmpty) {
                                return 'Pas de texte';
                              } else {
                                test = login;
                              }
                            }),
                        Row(
                          children: [
                            Text(
                              'Taille',
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
                            validator: (login) {
                              if (login == null || login.isEmpty) {
                                return 'Pas de texte';
                              } else {
                                test = login;
                              }
                            }),
                        Text('IMC'),
                        Row(
                          children: [
                            Text(
                              'Médicaments',
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
                            validator: (login) {
                              if (login == null || login.isEmpty) {
                                return 'Pas de texte';
                              } else {
                                test = login;
                              }
                            }),
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
                            validator: (login) {
                              if (login == null || login.isEmpty) {
                                return 'Pas de texte';
                              } else {
                                print('Test');
                              }
                            }),
                        SizedBox(height: 75,)
                      ]))
            )),
        floatingActionButton: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    MediBotColors.color3)),
            onPressed: () => print('Envoyer'),
            child: const Text(
              'Envoyer',
              style: TextStyle(fontSize: 20),
            )),
    );

  }
}
