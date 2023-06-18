import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(EarthquakeApp());
}

class EarthquakeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      home: EarthquakeListScreen(),
    );
  }
}

class EarthquakeListScreen extends StatefulWidget {
  @override
  _EarthquakeListScreenState createState() => _EarthquakeListScreenState();
}

class _EarthquakeListScreenState extends State<EarthquakeListScreen> {
  List<Earthquake> earthquakes = [];

  Future<void> fetchEarthquakes() async {
    final response = await http.get(Uri.parse(
        'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'];

      setState(() {
        earthquakes = features
            .map<Earthquake>((json) => Earthquake.fromJson(json))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEarthquakes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquakes'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: earthquakes.length,
        itemBuilder: (ctx, index) => ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EarthquakeDetailsScreen(earthquake: earthquakes[index]),
              ),
            );
          },
          leading: Icon(Icons.public, color: Colors.blue),
          title: Text(
            earthquakes[index].place,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          subtitle: Text(
            'Magnitude: ${earthquakes[index].magnitude}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class EarthquakeDetailsScreen extends StatelessWidget {
  final Earthquake earthquake;

  const EarthquakeDetailsScreen({Key? key, required this.earthquake})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${earthquake.date}',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text(
              'Details: ${earthquake.details}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${earthquake.location}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Magnitude: ${earthquake.magnitude}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Link: ${earthquake.link}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Earthquake {
  final String place;
  final double magnitude;
  final String date;
  final String details;
  final String location;
  final String link;

  Earthquake({
    required this.place,
    required this.magnitude,
    required this.date,
    required this.details,
    required this.location,
    required this.link,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];
    final place = properties['place'];
    final magnitude = properties['mag'].toDouble();
    final date =
        DateTime.fromMillisecondsSinceEpoch(properties['time']).toString();
    final details = properties['title'];
    final location = properties['place'];
    final link = 'www.moredetails .com';

    return Earthquake(
      place: place,
      magnitude: magnitude,
      date: date,
      details: details,
      location: location,
      link: link,
    );
  }
}
