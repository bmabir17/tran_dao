
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReliefMapPage extends StatefulWidget{
  ReliefMapPage();

  @override
  _ReliefMapPageState createState() => _ReliefMapPageState();
}

class _ReliefMapPageState extends State<ReliefMapPage>{
  Position _currentPosition;

  GoogleMapController mapController;
  // final LatLng _center = const LatLng(23.7805733,90.2792399);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
          title: Text("Tran dao, Relief Distribution Map"),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children:<Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition.latitude,_currentPosition.longitude),
                zoom: 11.0,
              ),
              markers: {
                  //Marker for current Location
                  Marker(
                    markerId: MarkerId("marker"),
                    position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                    infoWindow: InfoWindow(title: 'Current Location'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
                  )  
              },
            ),
            // Ref: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html#material.FloatingActionButton.2
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child:FloatingActionButton.extended(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: Text('New Relief'),
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
        
        
      );
  }

  // Reference https://alligator.io/flutter/geolocator-plugin/
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}