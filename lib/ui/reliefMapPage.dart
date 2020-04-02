
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReliefMapPage extends StatefulWidget{
  ReliefMapPage();

  @override
  _ReliefMapPageState createState() => _ReliefMapPageState();
}

class _ReliefMapPageState extends State<ReliefMapPage>{
  GoogleMapController mapController;
  final LatLng _center = const LatLng(23.7805733,90.2792399);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tran Koi, relief distribution'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 8.0,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: Text('New Relief'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      );
  }
}