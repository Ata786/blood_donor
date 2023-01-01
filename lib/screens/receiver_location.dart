import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/snapshot_image.dart';
import '../logic/your_location.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../model/User.dart';
import 'package:uuid/uuid.dart';

class ReceiverLocation extends StatefulWidget {
  const ReceiverLocation({Key? key}) : super(key: key);

  @override
  State<ReceiverLocation> createState() => _ReceiverLocationState();
}

class _ReceiverLocationState extends State<ReceiverLocation> {


  double? lat,lon;

  Completer<GoogleMapController> mapController = Completer();
  List<Marker> _markers = <Marker>[];

  TextEditingController placeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: FutureBuilder<Position>(
          future: getLocation(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              lat = snapshot.data!.latitude;
              lon = snapshot.data!.longitude;
              _markers.add(Marker(
                  markerId: MarkerId('defaulstId'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(lat!,lon!),
                  infoWindow: InfoWindow(title: placeController.text)
              ));
              return Stack(
                children: [
                  GoogleMap(
                    onMapCreated: onMapCreated,
                    markers: Set.of(_markers),
                    initialCameraPosition: CameraPosition(
                        zoom: 15,
                        target: LatLng(lat!,lon!)
                    ),
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    compassEnabled: true,
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: TextField(
                          controller: placeController,
                          decoration: InputDecoration(
                              hintText: 'Search Places',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none)
                              )
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }else if(snapshot.hasError){
              return Center(child: Text('error'),);
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: ()async{

          if(placeController.text == ''){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Place Select')));
          }else{

            List<Location> locations = await locationFromAddress(placeController.text);
            lat = locations.first.latitude;
            lon = locations.first.longitude;
            GoogleMapController controller = await mapController.future;

            controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(lat!,lon!),zoom: 15.0))).then((value){
              Future.delayed(Duration(seconds: 2)).then((value)async{
                Uint8List? uin8List = await controller.takeSnapshot();
                final tempDir = await getTemporaryDirectory();
                File file = await File('${tempDir.path}/image.jpg').create();
                file.writeAsBytesSync(uin8List!);

                testCompressAndGetFile(file, file.path).then((compressFile){
                  getUserId().then((value){
                    Navigator.pop(context,{'id': value.sId,'address': placeController.text,'screenShot': compressFile});
                  });
                });

              });
            });
          }

          setState(() {
            _markers.add(Marker(
                markerId: MarkerId('defaulstId'),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(lat!,lon!),
                infoWindow: InfoWindow(title: placeController.text)
            ));
          });

        },
        child: Icon(Icons.location_searching,color: Colors.black,),
      ),
    ));
  }

  void onMapCreated(GoogleMapController controller){
    mapController.complete(controller);
  }

  Future<Position> getLocation()async{

    Position position = await checkLocation();

    return position;
  }

  Future<User> getUserId()async{

    SharedPreferences shared = await SharedPreferences.getInstance();
    String? userId = shared.getString('user');

    Map<String,dynamic> userJson = jsonDecode(userId!);
    User user = User.fromJson(userJson);

    return user;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {

    var uuid = Uuid();
    String randomId = uuid.v4();

    final imageUri = Uri.parse(file.path);
    final String outputUri = imageUri.resolve('./${randomId}.jpg').toString();

    var result = await FlutterImageCompress.compressAndGetFile(
      file.path, outputUri,
      quality: 20,
      format: CompressFormat.jpeg
    );

    return result!;
  }


}