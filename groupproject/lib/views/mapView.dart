import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/constants.dart';
import 'mapmarker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapPage(title: 'Map'),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});
  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng currentLatLong = AppConstants.myLocation;
  late MapController _mapController;
  double zoom = 18;
  List<GeoLocation> tempList = [];
  bool havePermission = false;
  LatLng coordinates2 = AppConstants.myLocation;
  bool found = false;
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    askLocation();
    WebView.platform = AndroidWebView();
  }

  void zoomIn() {
    setState(() {
      if (zoom < 18) {
        zoom++;
        _mapController.move(coordinates2, zoom);
      }
    });
  }

  void zoomOut() {
    setState(() {
      if (zoom > 3) {
        zoom--;
        _mapController.move(coordinates2, zoom);
      }
    });
  }

  askLocation() async {
    await Geolocator.isLocationServiceEnabled().then((value) => null);
    await Geolocator.requestPermission().then((value) => null);
    await Geolocator.checkPermission().then((LocationPermission permission) {
      print("Check Location Permission: $permission");
    });
    await Geolocator.isLocationServiceEnabled()
        .then((value) => havePermission = value);
    if (havePermission == false) {
      await askLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Location>> coordinates = locationFromAddress(locationData[0]);
    print(coordinates);
    print(locationData[0]);
    coordinates.then((value) =>
        coordinates2 = LatLng(value[0].latitude, value[0].longitude));
    setState(() {});

    for (int i = 0; i < mapMarkers.length; i++) {
      tempList.add(mapMarkers[i]);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.location_searching_rounded),
            onPressed: () async {
              await getLatLong();
              found = true;
              setState(() {
                _mapController.move(coordinates2, zoom);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              zoomIn();
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              zoomOut();
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              minZoom: 3,
              maxZoom: 18,
              zoom: zoom,
              center: coordinates2,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/abdullahsrwr/clb2maty3000g14p4g8km9c5j/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJkdWxsYWhzcndyIiwiYSI6ImNsYjJsdXowZTA1bTMzd25tejNqYmlucDUifQ.cwePGwtXq3Nw1M43xblH1A",
                additionalOptions: {
                  'mapStyleId': AppConstants.mapBoxStyleId,
                  'accessToken': AppConstants.mapBoxAccessToken,
                },
              ),
              if (found == true)
                MarkerLayer(
                  markers: [
                    Marker(
                      height: 40,
                      width: 40,
                      point: currentLatLong,
                      builder: (_) => Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Marker(
                      height: 40,
                      width: 40,
                      point: coordinates2,
                      builder: (_) => Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              if (found == true)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [currentLatLong, coordinates2],
                      strokeWidth: 2.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await getLatLong();
              String url =
                  //https://www.google.com/maps/dir/?api=1&origin=Google+Pyrmont+NSW&destination=QVB&destination_place_id=ChIJISz8NjyuEmsRFTQ9Iw7Ear8&travelmode=walking
                  "https://www.google.com/maps/dir/?api=1&origin=${currentLatLong.latitude}%2C${currentLatLong.longitude}&destination=${coordinates2.latitude}%2C${coordinates2.longitude}&travelmode=driving";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              );
            },
            tooltip: 'Add Marker',
            child: const Icon(Icons.traffic_rounded,
                color: Color.fromRGBO(0, 255, 200, 1)),
            backgroundColor: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  getLatLong() async {
    isAdding = true;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      currentLatLong = LatLng(position.latitude, position.longitude);
    });
    isAdding = false;
  }

  bool isAdding = false;
}
