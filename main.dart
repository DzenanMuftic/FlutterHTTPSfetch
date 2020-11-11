//Import async load, convert to json, material and fatch from http
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//set counter to 1
int _counter = 1;

//set MyApp main scrn
void main() => runApp(MyApp());

//fetchAlbum from https
Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/$_counter');
//check in Debug counter ++
  // print('pokupio sam $_counter');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

//Define class Album
class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});
//convert Album
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

// create Stateful Widget
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// define state of MyApp main scrn
class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;
// change state - refresh scrn
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      futureAlbum = fetchAlbum();
    });
  }

// Build header
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Name on TAB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

//build Scaffold *mid scrn
        home: Scaffold(
          appBar: AppBar(title: Text('Clicked $_counter times')),
          body: Center(
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.title);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
//Build widget for https Album
            ),
          ),

// add Button
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ));
  }
}
