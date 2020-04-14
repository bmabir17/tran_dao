import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tran_dao/common/sign_in.dart';

class ReliefMapPage extends StatefulWidget{
  final Position currentPosition;
  ReliefMapPage({this.currentPosition});

  @override
  _ReliefMapPageState createState() => _ReliefMapPageState(currentPosition : currentPosition);
}

class _ReliefMapPageState extends State<ReliefMapPage>{
  Position _currentPosition;
  var currentPosition;
  GoogleMapController mapController;
  static const LatLng _center = const LatLng(23.7805733,90.2792399);
  
  final Set<Marker> _markers = {};
  final Set<Heatmap> _heatmaps = {};
  LatLng _lastMapPosition = _center;

  final databaseReference = Firestore.instance;
  bool loginStatus=false;
  
  

  void _onMapCreated(GoogleMapController controller) {
    
    mapController = controller;
  }
  _ReliefMapPageState({this.currentPosition});
  @override
  void initState() {
    _currentPosition = currentPosition;
    if(currentPosition == null){
      _getCurrentLocation();
    }
    getReliefData();
    checkLogin().then((bool stat){
      setState(() {
        loginStatus = stat;
      });
    });
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return 
      Stack(
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
            heatmaps: _heatmaps,
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
                  if (loginStatus){
                    _showQuantityModal(context);
                  }else{
                    Navigator.of(context).pushNamed('/login').then((value){
                      setState(() {
                        loginStatus = true;
                      });
                    });
                  }
                },
                label: Text('New Relief'),
                icon: Icon(Icons.add),
                backgroundColor: Colors.green[800],
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
      );
  }

  // Ref https://medium.com/@rajesh.muthyala/flutter-with-google-maps-and-google-place-85ccee3f0371
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
  // ------------------- View Functions ------------------------
  void _addMarker(orgName,quantity,packageType,location) {
    quantity=quantity.toString();
    if(location == null){
      location=_lastMapPosition;
    }
    setState(() {
      _markers.add(
        Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(
            title: 'Your/Organization Name: $orgName',
            snippet: '$packageType package with Quantity: $quantity ',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(0),
        )
      );
    });
  }
  // https://github.com/bmabir17/google_maps_flutter_heatmap/blob/master/example/lib/place_heatmap.dart
  void _addHeatmap(quantity,location){
    if(location == null){
      location=_lastMapPosition;
    }
    int rad = 10;
    if (quantity>200){
      if(quantity<10000){
        rad = 10 + (quantity/ 200).round();
      }
      rad = 50;  
      
    }
    setState(() {
      _heatmaps.add(
        Heatmap(
          heatmapId: HeatmapId(location.toString()),
          points: _createPoints(location,quantity),
          radius: rad,
          visible: true,
          gradient:  HeatmapGradient(colors: <Color>[Colors.green, Colors.red], startPoints: <double>[0.2, 0.8])
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
                        color: Colors.green[800],
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
                            createReliefRecord("Abir",_quantity,"Weekly");
                            Navigator.pop(context);
                            _addMarker("Abir",_quantity,"Weekly",null);
                            _addHeatmap(_quantity,null);
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
  // ------------------ I/O functions ------------
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
  // reference https://medium.com/@atul.sharma_94062/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27
  void createReliefRecord(name,quantity,packageType) async {
    DocumentReference ref = await databaseReference.collection("relief")
        .add({
          'name': name,
          'quantity': quantity,
          'location': GeoPoint(_lastMapPosition.latitude,_lastMapPosition.longitude),
          'package_type':packageType,
          'time':Timestamp.now()

        });

  }

  void getReliefData() {
    databaseReference
        .collection("relief")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        //  Ref https://fireship.io/lessons/flutter-realtime-geolocation-firebase/
        GeoPoint pos = f.data['location'];
        LatLng latLng = new LatLng(pos.latitude, pos.longitude);
        _addMarker(f.data['name'],f.data['quantity'],f.data['package_type'],latLng);
        _addHeatmap(f.data['quantity'],latLng);

      });
    });
  }

  //heatmap generation helper functions
  List<WeightedLatLng> _createPoints(LatLng location,quantity) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    points.add(_createWeightedLatLng(location.latitude,location.longitude, 1));
    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }
}

