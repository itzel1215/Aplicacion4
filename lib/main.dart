import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue, // Color principal de la aplicación
        fontFamily: 'Roboto', // Fuente predeterminada para la aplicación
        textTheme: TextTheme(
          // Personalización de los estilos de texto
          headline6: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black), // Estilo para el título
          subtitle1: TextStyle(
              fontSize: 16.0, color: Colors.grey), // Estilo para la descripción
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scrum Items',
              style: TextStyle(
                  fontFamily: 'Roboto')), // Aplicando la fuente personalizada
        ),
        body: ScrumItemsList(),
      ),
    );
  }
}

class ScrumItem {
  final String name;
  final String description;
  final String example;

  ScrumItem({
    required this.name,
    required this.description,
    required this.example,
  });

  factory ScrumItem.fromJson(Map<String, dynamic> json) {
    return ScrumItem(
      name: json['name'],
      description: json['description'],
      example: json['example'],
    );
  }
}

class ScrumItemsList extends StatefulWidget {
  @override
  _ScrumItemsListState createState() => _ScrumItemsListState();
}

class _ScrumItemsListState extends State<ScrumItemsList> {
  List<ScrumItem> scrumItems = [];

  @override
  void initState() {
    super.initState();
    loadScrumItems();
  }

  Future<void> loadScrumItems() async {
    String jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      scrumItems =
          jsonResponse.map((item) => ScrumItem.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: scrumItems.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2.0, // Elevación del card
          margin: EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 5.0), // Margen del card
          child: ListTile(
            title: Text(scrumItems[index].name,
                style: Theme.of(context)
                    .textTheme
                    .headline6), // Aplicando el estilo de texto definido en el theme
            subtitle: Text(scrumItems[index].description,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1), // Aplicando el estilo de texto definido en el theme
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(scrumItems[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text(scrumItems[index].example),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
