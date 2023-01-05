import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CheckConnection{


  static Future<bool> checkInternet(BuildContext context)async {

    try{

      bool net = await InternetConnectionChecker().hasConnection;

      if(net == true) {
        return true;
      } else {
        return false;
      }

    }catch(_){
      return false;
    }

  }

}