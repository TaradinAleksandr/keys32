import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NetPage());
}

class NetPage extends StatefulWidget {
  const NetPage({Key? key}) : super(key: key);

  @override
  _NetPageState createState() => _NetPageState();
}

class _NetPageState extends State<NetPage> {
  late Future<Post> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  TextStyle ts = const TextStyle(
    fontSize: 30,
    color: Colors.blueGrey
  );

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FutureBuilder<Post>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return
                    SizedBox(
                      width: 300,
                      height: 600,
                      child: ListView(
                        children: [
                          const Divider(color: Colors.blue, thickness: 1,),
                          Text('id: '+snapshot.data!.id.toString(), style: ts,),
                          const Divider(color: Colors.blue, thickness: 1,),
                          Text('userId: '+snapshot.data!.userId.toString(), style: ts,),
                          const Divider(color: Colors.blue, thickness: 1,),
                          Text('title: '+snapshot.data!.title, style: ts,),
                          const Divider(color: Colors.blue, thickness: 1,),
                        ],
                      ),
                    );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      );
  }
}

Future<Post> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;

  Post({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}