import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../main_ui/screen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../UserData/data.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
//import 'package:fluttertoast/fluttertoast.dart';

//var gid;

int len1 = 1;
TextEditingController msg = new TextEditingController();

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<String> listofmessages = new List();
  List<bool> types = new List();
  String gid;
  ScrollController listScrollController = new ScrollController();
  bool chatbot_check = false;
  @override
  void initState() {
    if (rid.toString() == 't490ac6sGfsBDDQJ9Gxi') {
      chatbot_check = true;
    }
    super.initState();
    if (Get().key.hashCode <= rid.hashCode) {
      gid = '${Get().key}-$rid';
    } else {
      gid = '$rid-${Get().key}';
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData query = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundImage: rname != 'Pigeon Bot'
                    ? NetworkImage(rpurl)
                    : AssetImage('images/d2.png'),
                radius: 18,
              ),
            ),
            Container(
              child: Text(rname),
              margin: EdgeInsets.only(right: 50),
            ),
          ],
        ),
        actions: <Widget>[Icon(Icons.more_vert)],
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: <Widget>[
          wallpaper(query),
          Positioned(
            top: 0.0,
            left: 5.0,
            right: 5.0,
            bottom: 65,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(gid)
                  .collection(gid)
                  .orderBy('time', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  //List listMessage = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return messageview(
                          index, query, snapshot.data.documents[index]);
                    },
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
          ),
          typebox(query),
        ],
      ),
    );
  }

  // void messageSender(String recieverid, String message) {
  //   msg.clear();

  //   var documentReference = Firestore.instance
  //       .collection('messages')
  //       .document(gid)
  //       .collection(gid)
  //       .document(DateTime.now().millisecondsSinceEpoch.toString());

  //   Firestore.instance.runTransaction((transaction) async {
  //     await transaction.set(
  //       documentReference,
  //       {
  //         "senderId": Get().key,
  //         "recieverId": recieverid,
  //         "message": message,
  //         "time": DateTime.now().millisecondsSinceEpoch.toString(),
  //       },
  //     );
  //   });
  //   listScrollController.animateTo(0.0,
  //       duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  // }

  Widget messageview(int index, MediaQueryData query, data) {
    bool check;
    check = data["senderId"].toString() == Get().key.toString() ? true : false;

    return Column(
      crossAxisAlignment:
          check ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              check ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: data["message"].toString().length >= 26
                  ? query.size.width / 1.4
                  : null,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color:
                      check ? Colors.lightGreenAccent.shade100 : Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisAlignment:
                    check ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                  data["message"].toString().length >= 26
                      ? Flexible(
                          child: Text(
                            data["message"].toString(),
                            maxLines: 100,
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      : Text(data["message"].toString(),style: TextStyle(fontSize: 15),)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget typebox(MediaQueryData query) {
    return Positioned(
      bottom: 3.0,
      left: 3.0,
      child: Container(
        //alignment: Alignment.bottomCenter,
        //color: Colors.white,
        //height: query.size.height * giveheight() / 10,
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.tag_faces),
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    width: query.size.width / 1.78,
                    child: TextField(
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type a message',
                      ),
                      controller: msg,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSubmitted: _textSubmitted,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left:8.0),
            //   child: CircleAvatar(
            //     child: IconButton(
            //       icon: Icon(
            //         Icons.send,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {
            //         return msg.text.isNotEmpty?sendMessage(msg.text):null;
            //       },
            //     ),
            //     maxRadius: 26,
            //     backgroundColor: Colors.teal,
            //     //radius: query.size.width / 12,
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.only(left: 8, bottom: 3),
              height: 55,
              child: FloatingActionButton(
                elevation: 3,
                onPressed: () {
                  String a = msg.text.trim();
                  if (a == "") {
                  } else {
                    return msg.text.isNotEmpty ? sendMessage(a) : null;
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _textSubmitted(String value) async {
    msg.clear();
  }

  void sendMessage(String message) async {
    _textSubmitted(message);

    Firestore.instance
        .collection('messages')
        .document(gid)
        .collection(gid)
        .document()
        .setData({
      "senderId": Get().key,
      "recieverId": rid,
      "message": message,
      "time": DateTime.now().millisecondsSinceEpoch.toString(),
    });
    if (chatbot_check) {
      AuthGoogle authGoogle = await AuthGoogle(
              fileJson: "assets/creds.json")
          .build();
      Dialogflow dialogflow =
          Dialogflow(authGoogle: authGoogle, language: Language.ENGLISH);

      AIResponse response = await dialogflow.detectIntent(message);
      print(response.getMessage());
      Firestore.instance
          .collection('messages')
          .document(gid)
          .collection(gid)
          .document()
          .setData({
        "senderId": rid,
        "recieverId": Get().key,
        "message": response.getMessage(),
        "time": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
    method1();
    setState(() {});
  }

  Future<Null> method1() async {
    listofmessages.clear();
    types.clear();
    final QuerySnapshot querysnap =
        await Firestore.instance.collection('messages').getDocuments();
    final List<DocumentSnapshot> msgs = querysnap.documents;
    for (int i = 0; i < msgs.length; i++) {
      if (Get().key == msgs[i]["senderId"] && rid == msgs[i]["recieverId"]) {
        types.add(true);
        listofmessages.add(msgs[i]["message"]);
      } else if (rid == msgs[i]["senderId"] &&
          Get().key == msgs[i]["recieverId"]) {
        types.add(false);
        listofmessages.add(msgs[i]["message"]);
      }
    }
  }

  int giveheight() {
    double len = msg.text.length / 20;
    int a = len.toInt();
    if (a > 3) {
      a = 3;
    } else if (a < 1) a = 1;
    setState(() {
      len1 = a;
    });
    return len1;
  }

  Widget wallpaper(MediaQueryData query) {
    return Container(
      color: Colors.blueGrey,
      height: query.size.height,
      width: query.size.width,
    );
  }

  Future<Null> chatbot_msg(String message) async {}
}
