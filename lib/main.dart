import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Title',
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<Home> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/cfwZmvEBbC?Indent=2");

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var user in jsonData) {
      User u = User(user["index"], user["name"], user["email"], user["about"],
          user["picture"]);

      users.add(u);
    }

    // print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Appbar"),
        ),
        body: Container(
          child: FutureBuilder(
              future: _getUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading...."),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data[index].picture),
                        ),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].email),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(snapshot.data[index])));
                        },
                      );
                    },
                  );
                }
              }),
        ));
  }
}

class User {
  final int index;
  final String name;
  final String email;
  final String about;
  final String picture;

  User(this.index, this.name, this.email, this.about, this.picture);
}

class DetailsPage extends StatelessWidget {
  final User user;

  DetailsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: Center(
          child: ListView(
        children: <Widget>[
          Text(
            user.about,
            style: TextStyle(color: Colors.pink, fontSize: 25),
          )
        ],
      )),
    );
  }
}
