import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medibot/home_page.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.username, required this.isCreate});

  final String username;
  final bool isCreate;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _login = '';
  String _createPassword = '';
  final _password = TextEditingController();

  void createUser() {
    if (_formKey.currentState!.validate()) {
      print('Login: ' + _login);
      print('Password: ' + _createPassword);
      Navigator.of(context).pop();
    }
  }

  void logIn() {
    print('Password: ' + _password.text);
    if (_password.text.length > 0) {
      // if correspond to local db
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    username: widget.username,
                  )));
    }
  }

  Widget signInIconButton(Icon profileIcon, String profileText) {
    return Column(
      children: [
        Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(2.0), // borde width
            decoration: const BoxDecoration(
              color: Colors.grey, // border color
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: profileIcon,
                onPressed: () {
                  print(widget.username);
                },
              ),
            )),
        Text(profileText)
      ],
    );
  }

  Widget createForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(MediBotTexts.login),
                  ],
                ),
                TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      filled: true,
                    ),
                    validator: (login) {
                      if (login == null || login.isEmpty) {
                        return 'Il manque un identifiant';
                      } else {
                        _login = login;
                      }
                    }),
                Row(
                  children: [
                    Text(MediBotTexts.password),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    filled: true,
                  ),
                  validator: (password) {
                    if (password == null ||
                        password.isEmpty ||
                        password.length < 8) {
                      return 'Pas assez de caractères';
                    } else {
                      _createPassword = password;
                    }
                  },
                  obscureText: true,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MediBotColors.color3)),
                  onPressed: () => createUser(),
                  child: Text('Ajouter mon profil'))
            ],
          )
        ],
      ),
    );
  }

  Widget loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        signInIconButton(Icon(Icons.person), widget.username),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Row(
                children: [
                  Text(MediBotTexts.password),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  filled: true,
                ),
                controller: _password,
                obscureText: true,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MediBotColors.color3)),
                onPressed: () => logIn(),
                child: Text('Connexion'))
          ],
        )
      ],
    );
  }

  Widget formMode() {
    if (widget.isCreate) {
      return createForm();
    } else {
      return loginForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child:
                  const Image(image: AssetImage('assets/images/logo/logo.png')),
            ),
            SizedBox(height: 5),
            formMode()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _password.dispose();
    super.dispose();
  }
}
