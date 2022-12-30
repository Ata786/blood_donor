import 'package:geolocator/geolocator.dart';

Future<Position> checkLocation()async{
  bool isEnable = await Geolocator.isLocationServiceEnabled();

  if(isEnable){
    LocationPermission checkPermission = await Geolocator.checkPermission();
    if(checkPermission == LocationPermission.denied){
      checkPermission = await Geolocator.requestPermission();
      if(checkPermission == LocationPermission.denied){
        checkPermission = await Geolocator.requestPermission();
        print('Permission denied');
      }else if(checkPermission == LocationPermission.deniedForever){
        print('Permission denied forever');
      }else{
        print('Permission granted');
      }
    }else{
      print('Permission granted');
    }
  }else{
    await Geolocator.openLocationSettings();
  }
  return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

