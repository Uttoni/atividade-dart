import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Joke> fetchJoke() async {
  final response = await http
      .get(Uri.parse('https://v2.jokeapi.dev/joke/Any?lang=en&blacklistFlags=racist,sexist&type=twopart'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Joke.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get a joke');
  }
}

class Joke {
  final String setUp;
  final String pun;

  const Joke({
    required this.setUp,
    required this.pun,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    
    return Joke(
      setUp: json['setup'],
      pun: json['delivery'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Joke> futureJoke;

  @override
  void initState() {
    super.initState();
    futureJoke = fetchJoke();
    print(futureJoke);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Joke>(
            future: futureJoke,
            builder: (context, snapshot) {

              if (snapshot.hasData) {
                return Text("The best pun jokes you've heard! \n\n\n\n" + "A: " + snapshot.data!.setUp + "\n\nB: " + snapshot.data!.pun);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();

            },
          )
        ),
      ),
    );
  }
}