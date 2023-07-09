import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Heroes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> heroes = [];
  List<dynamic> filteredHeroes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://indonesia-public-static-api.vercel.app/api/heroes'));

    if (response.statusCode == 200) {
      setState(() {
        heroes = json.decode(response.body) as List<dynamic>;
        filteredHeroes = heroes;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void filterHeroes(String query) {
    setState(() {
      filteredHeroes = heroes
          .where((hero) => hero['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Heroes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterHeroes(value),
              decoration: InputDecoration(
                labelText: 'Cari Nama Pahlawan',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHeroes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredHeroes[index]['name'] ?? ''),
                  subtitle: Text(filteredHeroes[index]['description'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}