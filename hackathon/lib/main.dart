import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'berlin_scooter.dart'; // Import the new page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berlin Scooter Hotspots',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF008080),
        scaffoldBackgroundColor: Color(0xFFF5F8FA),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF008080),
        scaffoldBackgroundColor: Color(0xFF1A1A1A),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      themeMode: ThemeMode.system,
      home: ScooterHotspotsPage(),
    );
  }
}

class ScooterHotspotsPage extends StatefulWidget {
  @override
  _ScooterHotspotsPageState createState() => _ScooterHotspotsPageState();
}

class _ScooterHotspotsPageState extends State<ScooterHotspotsPage> {
  bool isLoading = false;

  void _navigateToBerlinScooters() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BerlinScooterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Berlin Scooter Hotspots",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          // Placeholder for the map widget
          Center(child: Text('Map Placeholder', style: TextStyle(color: Colors.grey[400]))),
          // Introductory text card
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegend(Icons.location_pin, Colors.red, "Hotspots"),
                    _buildLegend(Icons.location_pin, Colors.blue, "Far Scooters"),
                    _buildLegend(Icons.location_pin, Colors.green, "Close Scooters"),
                  ],
                ),
              ),
            ),
          ),
          // Centered "View Scooters" Button
          Center(
            child: ElevatedButton(
              onPressed: _navigateToBerlinScooters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: Color(0xFF008080),
                shadowColor: Colors.black45,
                elevation: 8,
              ),
              child: Text(
                "View Scooters in Berlin Hotspots",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Refresh Button as FAB
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _navigateToBerlinScooters,
              child: Icon(Icons.refresh),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
