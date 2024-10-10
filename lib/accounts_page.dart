import 'package:flutter/material.dart';
import 'package:medibot/login_page.dart';
import 'package:medibot/services/main_service.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late List<String> userList;
  late Future<List<String>> futUserList;
  MainService service = MainService();

  @override
  void initState() {
    futUserList = service.getUserList();
    super.initState();
  }

  Widget profileIconButton(
      Icon profileIcon, String profileText, bool isCreate) {
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
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                username: profileText,
                                userList: userList,
                                isCreate: isCreate,
                              )
                      )
                  );
                  setState(() {
                    futUserList = service.getUserList();
                  });
                },
              ),
            )),
        Text(
          profileText,
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }

  Widget squares(int rowSize) {
    List<Widget> rowList = [];
    if (((userList.length) / rowSize).floor() > 0) {
      for (var i = 0; i < ((userList.length) / rowSize).floor(); i++) {
        List<Widget> btnList = [];
        for (var j = 0; j < rowSize; j++) {
          btnList.add(profileIconButton(
              Icon(Icons.person), userList[i * rowSize + j], false));

          if (i * rowSize + j == userList.length) {
            btnList.add(
                profileIconButton(Icon(Icons.add), MediBotTexts.add, true));
            j++;
          }
        }

        rowList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: btnList,
        ));

        rowList.add(const Row(
          children: [
            SizedBox(
              height: 25,
            )
          ],
        ));
      }
    }

    if (userList.length + 1 % rowSize != 0) {
      List<Widget> btnList = [];
      for (var j = 0; j < userList.length % rowSize; j++) {
        btnList.add(profileIconButton(
            Icon(Icons.person),
            userList[
                ((((userList.length - 1) / rowSize).floor())) * rowSize + j],
            false));
      }
      btnList.add(profileIconButton(Icon(Icons.add), MediBotTexts.add, true));
      rowList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: btnList,
      ));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: rowList);
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
              const Image(image: AssetImage('assets/images/logo/logo.png')),
              SizedBox(height: 10),
              Text(MediBotTexts.myProfiles, style: TextStyle(fontSize: 20)),
              SizedBox(height: 30),
              FutureBuilder(
                  future: futUserList,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      userList = snapshot.data!;
                      return squares(3);
                    }
                    else if(snapshot.hasError){
                      return Text(snapshot.error!.toString());
                    }
                    return CircularProgressIndicator();
                  }
              )
          ],
        )),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
