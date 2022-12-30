import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages.dart';
import '../model/User.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLogin();

  }

  void checkLogin()async{

    SharedPreferences shared = await SharedPreferences.getInstance();

    Future.delayed(Duration(seconds: 2)).then((value){

      String? user = shared.getString('user');

      if(user == null){
        Navigator.pushNamed(context, Routers.SIGN_IN_SCREEN);
        print('null');
      }else{

      Map<String,dynamic> userMap = jsonDecode(user);
      User userObject = User.fromJson(userMap);

      if(userObject.isLogin == true){
        if(userObject.type == 'Donor'){
          Navigator.pushNamed(context, Routers.HOME_SCREEN);
          print('id is ${userObject.sId} and type is ${userObject.type}');
        }else if(userObject.type == 'Receiver'){
          Navigator.pushNamed(context, Routers.RECEIVER_SCREEN);
          print('id is ${userObject.sId} and type is ${userObject.type}');
        }else{
          Navigator.pushNamed(context, Routers.SIGN_IN_SCREEN);
          print('id is ${userObject.sId} and type is ${userObject.type}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Not Found')));
        }

      }else{
        Navigator.pushNamed(context, Routers.SIGN_IN_SCREEN);
        print('nothing');
      }


      }

    });

  }
  

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Center(child: Text('Splash Screen'),),
        ),
      ),
    );
  }
}