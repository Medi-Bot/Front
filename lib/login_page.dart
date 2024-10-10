import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medibot/home_page.dart';
import 'package:medibot/services/main_service.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
      {super.key,
      required this.username,
      required this.userList,
      required this.isCreate});

  final String username;
  final List<String> userList;
  final bool isCreate;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _error = false;
  final _formKey = GlobalKey<FormState>();
  String _login = '';
  String _password = '';
  MainService service = MainService();

  void createUser() async {
    if (_formKey.currentState!.validate()) {
      print('Login: ' + _login);
      print('Password: ' + _password);
      await service.selectProfile(_login, _password);
      await service.selectProfile("", "");
      Navigator.of(context).pop();
    }
  }

  void logIn() async {
    if (_formKey.currentState!.validate())  {
      print('Login: ' + _login);
      print('Password: ' + _password);
      if(await service.selectProfile(_login, _password)){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                  username: widget.username,
                )));
      }
      else{
        setState(() {
          _error = true;
        });
      }
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
                child: profileIcon)),
        Text(
          profileText,
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  bool checkIsLoginAlreadyUsed(String login) {
    bool isAlreadyUsed = false;
    login = login.replaceAll(RegExp('_'), ' ');
    for (String user in widget.userList) {
      if (user == login.trim()) {
        isAlreadyUsed = true;
      }
    }

    return isAlreadyUsed;
  }

  Widget createForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      MediBotTexts.login,
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
                        return MediBotTexts.noLogin;
                      } else if (checkIsLoginAlreadyUsed(login)) {
                        return MediBotTexts.loginAlreadyExisting;
                      } else {
                        login.replaceAll(RegExp('_'), ' ');
                        _login = login.trim();
                      }
                    }),
                SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      MediBotTexts.password,
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
                  validator: (password) {
                    if (password == null ||
                        password.isEmpty ||
                        password.length < 8) {
                      return MediBotTexts.passwordTooShort;
                    } else {
                      _password = password;
                    }
                  },
                  obscureText: true,
                ),
              ],
            ),
          ),
          Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(MediBotColors.color3)),
                      onPressed: () => createUser(),
                      child: Text(
                        MediBotTexts.addMyProfile,
                        style: TextStyle(fontSize: 20),
                      )),
                  SizedBox(width: 10),
                ],
              ))
        ],
      ),
    );
  }

  Widget loginForm(String profileName) {
    _login = profileName;
    return Column(
      children: [
        Visibility(
          visible: _error,
            child: Text("Mauvais mot de passe")
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(children: [
            signInIconButton(Icon(Icons.person), widget.username),
            SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            MediBotTexts.password,
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
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return MediBotTexts.noPassword;
                          } else {
                            _password = password;
                          }
                        },
                        obscureText: true,
                      ),
                    ],
                  )),
            )
          ]),
        ),
        Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MediBotColors.color3)),
                  onPressed: () => logIn(),
                  child: Text(MediBotTexts.logIn)),
              SizedBox(width: 10),
            ],
          ),
        )
      ],
    );
  }

  Widget formMode() {
    if (widget.isCreate) {
      return createForm();
    } else {
      return loginForm(widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child:
                  const Image(image: AssetImage('assets/images/logo/logo.png')),
            ),
            SizedBox(height: 10),
            formMode()
          ],
        )),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
