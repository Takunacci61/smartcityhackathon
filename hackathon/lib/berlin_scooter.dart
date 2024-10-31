import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

class BerlinScooterPage extends StatefulWidget {
  @override
  _BerlinScooterPageState createState() => _BerlinScooterPageState();
}

class _BerlinScooterPageState extends State<BerlinScooterPage> {
  final String apiKey = "API KEY HERE";
  final LatLng berlinCenter = LatLng(52.5200, 13.4050);
  final MapController _mapController = MapController();

  List<Marker> markers = [];
  bool isLoading = true;
  bool showNearHotspotsOnly = false;

  List<Map<String, String>> scooters = [];

  final List<Map<String, dynamic>> berlinHotspots = [
    {"name": "Berlin Central Station", "location": LatLng(52.5251, 13.3694)},
    {"name": "Alexanderplatz", "location": LatLng(52.5219, 13.4132)},
    {"name": "Brandenburg Gate", "location": LatLng(52.5163, 13.3777)},
    {"name": "Potsdamer Platz", "location": LatLng(52.5096, 13.3762)},
    {"name": "Berlin Zoo", "location": LatLng(52.5080, 13.3380)},
    {"name": "East Side Gallery", "location": LatLng(52.5057, 13.4390)},
    {"name": "Mauerpark", "location": LatLng(52.5433, 13.4135)},
    {"name": "Kurfürstendamm", "location": LatLng(52.5019, 13.3295)},
    {"name": "Tempelhofer Feld", "location": LatLng(52.4731, 13.4063)},
    {"name": "Hackescher Markt", "location": LatLng(52.5236, 13.4010)},
    {"name": "Main Office", "location": LatLng(52.447651, 13.593465)},
    {"name": "Branch Office", "location": LatLng(52.480956, 13.492754)},
    {"name": "Friedrichshain Park", "location": LatLng(52.5286, 13.4483)},
    {"name": "Boxhagener Platz", "location": LatLng(52.5145, 13.4650)},
    {"name": "RAW Gelände", "location": LatLng(52.5059, 13.4544)},
    {"name": "Volkspark Friedrichshain", "location": LatLng(52.5292, 13.4328)},
    {"name": "Oberbaum Bridge", "location": LatLng(52.5019, 13.4457)},
    {"name": "Simon-Dach-Straße", "location": LatLng(52.5158, 13.4642)},
    {"name": "Samariterstraße", "location": LatLng(52.5155, 13.4752)},
    {"name": "Kreuzberg Park", "location": LatLng(52.4885, 13.3969)},
    {"name": "Görlitzer Park", "location": LatLng(52.4961, 13.4443)},
    {"name": "Treptower Park", "location": LatLng(52.4935, 13.4695)},
    {"name": "Rosa-Luxemburg-Platz", "location": LatLng(52.5299, 13.4106)},
    {"name": "Karl-Marx-Allee", "location": LatLng(52.5227, 13.4395)},
    {"name": "Weißensee Park", "location": LatLng(52.5563, 13.4667)},
    {"name": "Plänterwald", "location": LatLng(52.4846, 13.4675)},
    {"name": "Charlottenburg Palace", "location": LatLng(52.5204, 13.2953)},
    {"name": "Westend", "location": LatLng(52.5136, 13.2776)},
    {"name": "Schöneberg", "location": LatLng(52.4828, 13.3574)},
    {"name": "Museum Island", "location": LatLng(52.5169, 13.4014)}
  ];

  @override
  void initState() {
    super.initState();
    _initializeHotspots();
    _fetchScooterData();
  }

  void _initializeHotspots() {
    for (var hotspot in berlinHotspots) {
      markers.add(
        Marker(
          point: hotspot['location'],
          width: 50.0,
          height: 50.0,
          builder: (ctx) => GestureDetector(
            onTap: () => _showMarkerInfo(hotspot['name']),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 20,
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _fetchScooterData() async {
    final scooterIdEndpoint =
        "https://api.mkdx.btcsp.co.uk/data-service/sensors/feeds/96c370cf-1d10-4570-bd0e-463570cff1e1/1/datastream/1/datapoints?limit=100";
    final latitudeEndpoint =
        "https://api.mkdx.btcsp.co.uk/data-service/sensors/feeds/96c370cf-1d10-4570-bd0e-463570cff1e1/1/datastream/2/datapoints?limit=100";
    final longitudeEndpoint =
        "https://api.mkdx.btcsp.co.uk/data-service/sensors/feeds/96c370cf-1d10-4570-bd0e-463570cff1e1/1/datastream/3/datapoints?limit=100";

    List<String> scooterIds = await _fetchData(scooterIdEndpoint);
    List<String> latitudes = await _fetchData(latitudeEndpoint);
    List<String> longitudes = await _fetchData(longitudeEndpoint);

    // Ensure all lists have the same length
    int minLength = [
      scooterIds.length,
      latitudes.length,
      longitudes.length
    ].reduce((a, b) => a < b ? a : b);

    scooters = List.generate(
      minLength,
          (index) => {
        'id': scooterIds[index],
        'latitude': latitudes[index],
        'longitude': longitudes[index]
      },
    );

    _mapScooters(scooters);
    setState(() {
      isLoading = false;
    });
  }

  Future<List<String>> _fetchData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(endpoint), headers: {
        "x-api-key": apiKey,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        List<String> values = [];
        for (var entry in data) {
          String value = entry['value'] ?? '';
          List<String> splitValues = value.split(';');
          values.addAll(splitValues);
        }
        return values;
      } else {
        print('Error fetching data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  void _mapScooters(List<Map<String, String>> scooters) {
    for (var scooter in scooters) {
      final double? lat = double.tryParse(scooter['latitude'] ?? '');
      final double? lon = double.tryParse(scooter['longitude'] ?? '');

      if (lat == null || lon == null || lat == 0 || lon == 0) {
        print("Skipping scooter with invalid coordinates: ${scooter['id']}");
        continue;
      }

      final LatLng scooterLocation = LatLng(lat, lon);
      bool isNearHotspot = false;

      for (var hotspot in berlinHotspots) {
        final double distance = Geolocator.distanceBetween(
          lat,
          lon,
          hotspot['location'].latitude,
          hotspot['location'].longitude,
        );
        if (distance <= 500) {
          isNearHotspot = true;
          break;
        }
      }

      markers.add(
        Marker(
          point: scooterLocation,
          width: 50.0,
          height: 50.0,
          builder: (ctx) => GestureDetector(
            onTap: () => _showMarkerInfo("Scooter ID: ${scooter['id']}"),
            child: CircleAvatar(
              backgroundColor: isNearHotspot ? Colors.green : Colors.blue,
              radius: 20,
              child: Icon(
                Icons.electric_scooter,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  void _showMarkerInfo(String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(info),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _toggleFilter() {
    setState(() {
      showNearHotspotsOnly = !showNearHotspotsOnly;
      markers = markers.where((marker) {
        final CircleAvatar avatar =
        ((marker.builder(context) as GestureDetector).child)
        as CircleAvatar;
        final markerColor = avatar.backgroundColor;
        return showNearHotspotsOnly
            ? markerColor == Colors.green || markerColor == Colors.red
            : true;
      }).toList();
    });
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  void _selectRandomScooter() {
    if (scooters.isNotEmpty) {
      final randomIndex = Random().nextInt(scooters.length);
      final scooter = scooters[randomIndex];

      final double? lat = double.tryParse(scooter['latitude'] ?? '');
      final double? lon = double.tryParse(scooter['longitude'] ?? '');

      if (lat != null && lon != null) {
        final LatLng scooterLocation = LatLng(lat, lon);
        _mapController.move(scooterLocation, 16.0);
        _showMarkerInfo("Scooter ID: ${scooter['id']}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Berlin Scooters"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(showNearHotspotsOnly ? Icons.filter_alt : Icons.filter_alt_off),
            onPressed: _toggleFilter,
            tooltip: "Toggle near hotspots only",
          ),
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(berlinCenter, 13.0);
            },
            tooltip: "Re-center map",
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: berlinCenter,
              zoom: 13.0,
              maxZoom: 18.0,
              minZoom: 5.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.berlin_scooter_app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(Icons.location_on, Colors.red, "Hotspot"),
                      SizedBox(width: 10),
                      _buildLegendItem(Icons.electric_scooter, Colors.green, "Scooter near hotspot"),
                      SizedBox(width: 10),
                      _buildLegendItem(Icons.electric_scooter, Colors.blue, "Scooter far"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: _zoomIn,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.zoom_in),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: _zoomOut,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: FloatingActionButton.extended(
              heroTag: 'randomScooter',
              onPressed: _selectRandomScooter,
              backgroundColor: Colors.teal,
              icon: Icon(Icons.shuffle),
              label: Text("Random Scooter"),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
