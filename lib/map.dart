import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late Position? userLocation;
  late GoogleMapController _mapController;

  void _onMapCreate(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<Position?> _getLocation() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
        // กำหนดค่าความแม่นยำ
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      userLocation = null;
    }
    return userLocation; // return ตำแหน่งปัจจุบันออกไป
  }

  late LatLng latLng = LatLng(userLocation!.latitude, userLocation!.longitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Google Maps'),
      ),
      body: FutureBuilder(
        future: _getLocation(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreate,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: latLng,
                zoom: 15,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 18));
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                    'Your Location has been send ! , lat${userLocation!.latitude}, long${userLocation!.longitude}'),
              );
            },
          );
        },
        label: Text('Send Location'),
        icon: Icon(Icons.near_me),
      ),
    );
  }
}
