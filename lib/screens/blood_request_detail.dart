import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({Key? key}) : super(key: key);

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {

  List<Marker> marker = [];

  @override
  Widget build(BuildContext context) {

    Map<String,dynamic> requestData = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    var data = requestData['requestData'];
    var image = requestData['image'];
    String location = data[6];
    var requestImage = requestData['requestImage'];

    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: SlidingUpPanel(
        panelBuilder: (controller) => panelBody(myHeight, myWidth, data, image,requestImage),
        body: FutureBuilder<Location>(
          future: getLocation(location),
          builder: (context,snapshot){
            if(snapshot.hasData){
              marker.add(Marker(markerId: MarkerId('defaultId'),icon: BitmapDescriptor.defaultMarker,
                position: LatLng(snapshot.data!.latitude,snapshot.data!.longitude)));
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data!.latitude,snapshot.data!.longitude),
                  zoom: 15,
                ),
                markers: Set.of(marker),
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        parallaxEnabled: true,
        parallaxOffset: .5,
      )
    ));
  }

  Future<Location> getLocation(String location)async{

    List<Location> locations = await locationFromAddress(location);
    print('location is ${location} and lat is ${locations.first.latitude} and lon is ${locations.first.longitude}');
    return locations.first;
  }

  Widget panelBody(double myHeight,double myWidth,var data,var image,var requestImage){
    return ListView(
      children: [
        SizedBox(height: 12,),
        Center(child: Container(
          height: 5,
          width: 30,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(12))
          ),
        ),),
        SizedBox(height: myHeight/30,),
        Center(child: CircleAvatar(backgroundImage: NetworkImage('${requestImage}'),radius: myWidth/10,)),
        SizedBox(height: myHeight/30,),
        Row(
          children: [
            SizedBox(width: myWidth/20,),
            Text('Reveiver Name :-',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w900),),
            SizedBox(width: myWidth/30,),
            Text('${data[1]}',),
          ],
        ),
        SizedBox(height: myHeight/40,),
        Row(
          children: [
            SizedBox(width: myWidth/20,),
            Text('Patient Name :-',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w900),),
            SizedBox(width: myWidth/30,),
            Text('${data[2]}',),
          ],
        ),
        SizedBox(height: myHeight/40,),
        Row(
          children: [
            SizedBox(width: myWidth/20,),
            Text('Contact Number :-',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w900),),
            SizedBox(width: myWidth/30,),
            Text('${data[3]}',),
          ],
        ),
        SizedBox(height: myHeight/40,),
        Row(
          children: [
            SizedBox(width: myWidth/20,),
            Text('Blood Group :-',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w900),),
            SizedBox(width: myWidth/30,),
            Text('${data[5]}',),
          ],
        ),
        SizedBox(height: myHeight/40,),
        Row(
          children: [
            SizedBox(width: myWidth/20,),
            Text('Location :-',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w900),),
            SizedBox(width: myWidth/30,),
            Text('${data[6]}',),
          ],
        ),
        SizedBox(height: myHeight/40,),
        Row(
          children: [
            SizedBox(width: myWidth/20,),
            Text('Reason :-',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w900),),
            SizedBox(width: myWidth/30,),
            Expanded(child: Text('${data[4]}',)),
          ],
        ),
        SizedBox(height: myHeight/40,),
      ],
    );
  }

}
