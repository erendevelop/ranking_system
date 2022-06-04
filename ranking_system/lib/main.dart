import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RatingPage(),
    debugShowCheckedModeBanner: false,
  ));
}

Column yorumlar = Column(
  children: [],
);

var firebase = FirebaseFirestore.instance;

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int puan = 0;
  Map colors = {
    "color1": Colors.blue,
    "color2": Colors.blue,
    "color3": Colors.blue,
    "color4": Colors.blue,
    "color5": Colors.blue,
  };
  var yorum = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: MediaQuery.of(context).size.width / 6),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurStyle: BlurStyle.values[1],
                            blurRadius: 20)
                      ]),
                  padding: EdgeInsets.all(0.5),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextFormField(
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        ),
                        hintText: "Öğrenci ara...",
                      ),
                    ),
                  )),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {},
              color: Colors.black,
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leadingWidth: 120,
                toolbarHeight: 120,
                leading: Container(
                  margin: EdgeInsets.all(10),
                  width: 100,
                  height: 100,
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage("https://i.imgur.com/QbORlnz.jpeg"),
                      maxRadius: 80,
                      minRadius: 40,
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nickname",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Text(
                      "Name",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
                floating: true,
                pinned: true,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                              color: Colors.grey,
                            )),
                        SizedBox(
                          child: Center(
                            child: Text(
                              "Rank the user!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.values[5]),
                            ),
                          ),
                          height: 100,
                        ),
                        Center(
                          child: Row(
                            children: [
                              for (int i = 1; i < 6; i++)
                                Container(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        colors = {
                                          "color1": Colors.blue,
                                          "color2": Colors.blue,
                                          "color3": Colors.blue,
                                          "color4": Colors.blue,
                                          "color5": Colors.blue,
                                        };
                                        colors["color$i"] = Colors.green;
                                      });
                                      puan = i;
                                    },
                                    child: Text(
                                      "$i",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: colors["color$i"]),
                                ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      "Comment something.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                TextFormField(
                                  decoration: InputDecoration(),
                                  controller: yorum,
                                ),
                                TextButton(
                                  child: Text("Send"),
                                  onPressed: () async {
                                    var cevapScore = await firebase
                                        .collection("veriler")
                                        .doc("rankingScores")
                                        .get();
                                    var cevapYorum = await firebase
                                        .collection("veriler")
                                        .doc("reasons")
                                        .get();
                                    var verilerScore = cevapScore.data();
                                    var verilerYorum = cevapYorum.data();
                                    if(puan != 0)
                                      firebase
                                          .collection("veriler")
                                          .doc("rankingScores")
                                          .update({
                                        "score${verilerScore!.length + 1}": puan
                                      });

                                    for (int i = 0; i < yorum.text.length; i++) {
                                      if (yorum.text[i] == " ") {
                                      } else {
                                        firebase
                                            .collection("veriler")
                                            .doc("reasons")
                                            .update({
                                          "reason${verilerYorum!.length + 1}":
                                          yorum.text
                                        });
                                        break;
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  child: Text(
                                    "Comment",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: firebase
                                      .collection("veriler")
                                      .doc("reasons")
                                      .snapshots(),
                                  builder: (context, AsyncSnapshot asyncSnapshot) {
                                    return Column(
                                      children: [
                                        for (int i = 1;
                                        i <
                                            asyncSnapshot.data
                                                .data()
                                                .values
                                                .length +
                                                1;
                                        i++)
                                          ListTile(
                                            title: Text("Comment $i", style: TextStyle(fontSize: 14)),
                                            subtitle: Text(
                                              "${asyncSnapshot.data.data()["reason$i"]}", style: TextStyle(fontSize: 14),),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          child: Text("Made by ern\nhttps://github.com/ernkedy", textAlign: TextAlign.right, style: TextStyle(fontSize: 10),),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    );
                  }, childCount: 1))
            ],
          )),
    );
  }
}
