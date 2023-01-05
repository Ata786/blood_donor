import 'package:blood_bank/colors.dart';
import 'package:flutter/material.dart';

class CustomDialog{

  double? myHeight,myWidth;

  CustomDialog(double height,double width){
    myHeight = height;
    myWidth = width;
  }

  Widget progressDialog(){
    return Container(
      height: myHeight!/17,
      width: myWidth!/1.7,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(color: Color(CustomColors.PRIMARY_COLOR),),
          Text('Loading...',style: TextStyle(fontSize: myWidth!/20),)
        ],
      ),
    );
  }

  Widget internetDialog(){
    return Container(
      height: myHeight!/4,
      width: myWidth!/1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Connection Error'),
          Image.asset('assets/no_wifi.png')
        ],
      )
    );
  }


}