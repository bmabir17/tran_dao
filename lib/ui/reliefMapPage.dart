
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
  static const LatLng _center = const LatLng(23.7805733,90.2792399);

  final Set<Marker> _markers = {
                  //Marker for current Location
                  // Marker(
                  //   markerId: MarkerId("marker"),
                  //   position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                  //   infoWindow: InfoWindow(title: 'Current Location'),
                  //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
                  // )  
              };
  LatLng _lastMapPosition = _center;
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
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            // Ref: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html#material.FloatingActionButton.2
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child:FloatingActionButton.extended(
                  onPressed: () {
                    _showQuantityModal(context);
                    // showModalBottomSheet(context: context, builder: (context)=> Container(
                    //       color: Colors.red,
                    //     ));
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

  // Ref https://medium.com/@rajesh.muthyala/flutter-with-google-maps-and-google-place-85ccee3f0371
  void _onCameraMove(CameraPosition position) {
  _lastMapPosition = position.target;
  }
  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Really cool place',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        )
      );
    });

  }
  _showQuantityModal(context){
    final _formKey = GlobalKey<FormState>();
    showModalBottomSheet(context: context, builder: (context)=> Container(
                          color: Colors.red,
                          child:Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your email',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      // Validate will return true if the form is valid, or false if
                                      // the form is invalid.
                                      if (_formKey.currentState.validate()) {
                                        // Process data.
                                      }
                                    },
                                    child: Text('Submit'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
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