import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Maps extends StatefulWidget {
  String phoneNo;
  Maps({this.phoneNo});
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Timer _timer;
  _MapsState() {
    _timer = new Timer(const Duration(seconds: 4), () {
      setState(() {
        _setCircles();
      });
    });
  }
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polyline> _polylines = HashSet<Polyline>();
  Set<Circle> _circles = HashSet<Circle>();
  bool _showMapStyle = false;

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  Map data;
  List circleData;
  List _tempList = [];

  void getData() async {
    http.Response response =
        await http.get('https://bref-croissant-48789.herokuapp.com/getall');
    if (response.statusCode == 200) {
      List parsedJson = json.decode(response.body);
      for (var res in parsedJson) {
        print(res['centerx']);
        _tempList.add(res);
        print(_tempList);
      }
    } else {
      throw Exception('Failed to get all countries names');
    }
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // _setMarkerIcon();
    // _setPolygons();
    // _setPolylines();
    getData();
  }

  // void _setMarkerIcon() async {
  //   _markerIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/images/car_icon.png');
  // }

  // void _toggleMapStyle() async {
  //   String style = await DefaultAssetBundle.of(context)
  //       .loadString('assets/map_style.json');

  //   if (_showMapStyle) {
  //     _mapController.setMapStyle(style);
  //   } else {
  //     _mapController.setMapStyle(null);
  //   }
  // }

  // void _setPolygons() {
  //   List<LatLng> polygonLatLongs = List<LatLng>();
  //   polygonLatLongs.add(LatLng(37.78493, -122.42932));
  //   polygonLatLongs.add(LatLng(37.78693, -122.41942));
  //   polygonLatLongs.add(LatLng(37.78923, -122.41542));
  //   polygonLatLongs.add(LatLng(37.78923, -122.42582));

  //   _polygons.add(
  //     Polygon(
  //       polygonId: PolygonId("0"),
  //       points: polygonLatLongs,
  //       fillColor: Colors.white,
  //       strokeWidth: 1,
  //     ),
  //   );
  // }

  // void _setPolylines() {
  //   List<LatLng> polylineLatLongs = List<LatLng>();
  //   polylineLatLongs.add(LatLng(37.74493, -122.42932));
  //   polylineLatLongs.add(LatLng(37.74693, -122.41942));
  //   polylineLatLongs.add(LatLng(37.74923, -122.41542));
  //   polylineLatLongs.add(LatLng(37.74923, -122.42582));

  //   _polylines.add(
  //     Polyline(
  //       polylineId: PolylineId("0"),
  //       points: polylineLatLongs,
  //       color: Colors.purple,
  //       width: 1,
  //     ),
  //   );
  // }
  void _setCircles() {
    print("hello");
    _circles.add(
      Circle(
          circleId: CircleId('0'),
          center: LatLng(29.4698326, 77.7139136),
          radius: 1000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );

    _circles.add(
      Circle(
          circleId: CircleId('1'),
          center: LatLng(29.4143554039, 77.7384911384),
          radius: 1000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );
    int _counter = 2;
    for (var res in _tempList) {
      print(res['centerx']);
      _circles.add(
        Circle(
            circleId: CircleId(_counter.toString()),
            center: LatLng(res['centerx'], res['centery']),
            radius: 1000,
            strokeWidth: 2,
            fillColor: Color.fromRGBO(102, 51, 153, .5)),
      );
      _counter++;

      print(_circles);
    }
    print('Helo');
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // setState(() {
    //   _markers.add(
    //     Marker(
    //         markerId: MarkerId("0"),
    //         position: LatLng(37.77483, -122.41942),
    //         infoWindow: InfoWindow(
    //           title: "San Francsico",
    //           snippet: "An Interesting city",
    //         ),
    //         icon: _markerIcon),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    print(_currentPosition);
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(29.4698326, 77.7139136),
                zoom: 12,
              ),
              // markers: _markers,
              // polygons: _polygons,
              // polylines: _polylines,
              circles: _circles,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            _mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            _mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          _mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
