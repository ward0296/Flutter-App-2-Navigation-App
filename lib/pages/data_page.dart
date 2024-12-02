import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/data_model.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Future<List<DataModel>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<List<DataModel>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=15'));

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((user) {
        return DataModel(
          name: '${user['name']['first']} ${user['name']['last']}',
          email: user['email'],
        );
      }).toList();
    } else {
      throw Exception('Error, Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Page')),
      body: FutureBuilder<List<DataModel>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
