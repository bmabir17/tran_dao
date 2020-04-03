
import 'package:flutter/services.dart';
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
  
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  void _onMapCreated(GoogleMapController controller) {
    
    mapController = controller;
  }
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ত্রান দাও : Relief Distribution Map"),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children:<Widget>[
            _currentPosition != null ? GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target:  LatLng(_currentPosition.latitude,_currentPosition.longitude),
                zoom: 11.0,
              ),
              markers: _markers,
              onCameraMove: _onCameraMove,
            ):
            Center(
              child: CircularProgressIndicator(),
            ),
            // Ref: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html#material.FloatingActionButton.2
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child:FloatingActionButton.extended(
                  onPressed: () {
                    _showQuantityModal(context);
                  },
                  label: Text('New Relief'),
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
            _currentPosition != null ? Padding(
              padding: const EdgeInsets.all(0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 50.0,
                )
              ),
            ):Center(
              child:Text("Loading Map"),
            ),
          ],
        ), 
      );
  }

  // Ref https://medium.com/@rajesh.muthyala/flutter-with-google-maps-and-google-place-85ccee3f0371
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
  void _onAddMarkerButtonPressed(orgName,quantity,packageType) {
    quantity=quantity.toString();
    setState(() {
      _markers.add(
        Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Your/Organization Name: $orgName',
            snippet: '$packageType package with Quantity: $quantity ',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(0),
        )
      );
    });
  }
  _showQuantityModal(context){
    final _formKey = GlobalKey<FormState>();
    int _quantity;
    showModalBottomSheet(context: context, 
      builder: (context)=> Container(
        color: Colors.red[50],
        height: 180,
        child:Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:Align(
                      alignment: Alignment.topCenter,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Enter your relief Quantity',
                            icon: Icon(Icons.add_box),
                          ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some number';
                          }
                          return null;
                        },
                        onChanged: (value){
                          setState(() {
                            _quantity = int.parse(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 140.0),
                    child:Align(
                      alignment: Alignment.center,
                      child: RaisedButton.icon(
                        icon: Icon(Icons.save, color:Colors.white),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Colors.green,
                        label: Text('Submit',style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder( 
                          borderRadius: new BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.red[50])
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // Process data.
                            Navigator.pop(context);
                            debugPrint("_quantity: $_quantity");
                            _onAddMarkerButtonPressed("Abir",_quantity,"Weekly");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  // Reference https://alligator.io/flutter/geolocator-plugin/
   _getCurrentLocation () {
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