import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocalInfoScreen extends StatefulWidget {
  @override
  _LocalInfoScreenState createState() => _LocalInfoScreenState();
}

class _LocalInfoScreenState extends State<LocalInfoScreen> {
  late GoogleMapController _controller;
  final Location locationService = Location();
  LatLng _currentLocation = LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    print('Map created');
  }

  Future<void> _getCurrentLocation() async {
    final locationData = await locationService.getLocation();
    print('Location data: $locationData');
    setState(() {
      _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
    print('Current location: $_currentLocation');
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff8efd3),
        title: Image.asset('assets/images/hylian_info.png', fit: BoxFit.cover),
      ),
      body: _currentLocation == LatLng(0, 0)
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation,
                  zoom: 14.0,
                ),
              ),
              IgnorePointer(
                child: Positioned.fill(
                  child: Image.asset(
                    'assets/images/clouds.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Get Current Location',
        child: Icon(Icons.my_location),
      ),
    );
  }
}
