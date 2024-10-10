import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medibot/models/all_data_dto.dart';
import 'package:medibot/services/main_service.dart';
import 'package:medibot/src/medibots_colors.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key, required this.username});

  final String username;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  TextEditingController messageController = TextEditingController();
  late Future<AllDataDto> data;
  MainService service = MainService();

  @override
  void initState() {
    data = service.getAll();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MediBotColors.white,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pop(),
                child: const Image(
                    image: AssetImage('assets/images/logo/logo.png')),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.person,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error!.toString());
                  } else {
                    AllDataDto dto = snapshot.data!;
                    return ListView.builder(
                        itemCount: dto.historiqueCommunications.length * 2,
                        reverse: true,
                        itemBuilder: (context, index) {
                          index = dto.historiqueCommunications.length * 2 - index - 1;
                          bool isReceived = index % 2 == 1;
                          String message = isReceived ? dto.historiqueCommunications[index ~/ 2].reponse : dto.historiqueCommunications[index ~/ 2].message;
                          return Align(
                            alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.all(12.0),  // Augmenté le padding pour une meilleure apparence
                              margin: isReceived
                                  ? EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 80.0)  // Marge à gauche pour les messages reçus
                                  : EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0, left: 80.0),  // Marge à droite pour les messages envoyés
                              decoration: BoxDecoration(
                                  color: isReceived ? MediBotColors.color3 : MediBotColors.color2,  // Couleur différente pour les messages reçus et envoyés
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.black)
                              ),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,  // Limite la largeur du conteneur à 70% de la largeur de l'écran
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  }
                }
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        filled: true,
                      ),
                    )
                ),
                ElevatedButton(
                    onPressed: () async {
                      await service.sendMessage(messageController.text);
                      setState(() {
                        data = service.getAll();
                      });
                    },
                    child: Text("Envoyer")
                )
              ],
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
