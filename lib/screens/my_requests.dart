import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../colors.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({Key? key}) : super(key: key);

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> with TickerProviderStateMixin {

  Completer<GoogleMapController> mapController = Completer();
  List<Marker> _marker = [];

  BitmapDescriptor? icon;
  

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    _marker.add(Marker(markerId: MarkerId('defaultId'),
        position: LatLng(29.143644,71.257240),
        icon: BitmapDescriptor.defaultMarker));

    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: Column(
          children: [
            Container(
              height: myHeight/1.7,
              width: myWidth,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller){
                  mapController.complete(controller);
                },
                compassEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(29.143644,71.257240),
                  zoom: 12
                ),

                markers: Set.of(_marker),
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
          ],
        ),
      ),
    ));
  }


}
