import 'dart:convert';
import 'dart:io';

import 'package:blood_bank/logic/contract_linking.dart';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import '../colors.dart';
import '../logic/your_location.dart';
import '../model/User.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Client? httpClient;
  Web3Client? web3client;
  SharedPreferences? toggleShared;
  int toggle = 0;

  String rpcUrl = 'http://192.168.100.36:7545';

  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
    preference();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme:  IconThemeData(
            color: Colors.black,
          ),
          title: Text('Profile',style: TextStyle(color: Colors.black),),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: myHeight/20,),
              Row(
                children: [
                  Container(
                    margin:EdgeInsets.only(left: myWidth/20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: FutureBuilder<User>(
                        future: getUser(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return CircleAvatar(backgroundImage: NetworkImage('${snapshot.data!.image}'),
                              radius: myWidth / 10,backgroundColor: Colors.green,);
                          }else{
                            return Shimmer.fromColors(child: CircleAvatar(child: Image.asset('assets/man.png'),
                              radius: myWidth / 10,backgroundColor: Colors.green,),
                                baseColor: Colors.grey, highlightColor: Colors.white);
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: myWidth/30),
                    child: FutureBuilder<User>(
                      future: getUser(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Text('${snapshot.data!.name}',style: TextStyle(fontSize: myWidth / 20),);
                        }else{
                          return Shimmer.fromColors(child: Text('Your Name',style: TextStyle(fontSize: myWidth / 20),),
                              baseColor: Colors.grey, highlightColor: Colors.white);
                        }
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: myWidth/20,top: myWidth/10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<User>(
                      future: getUser(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Text('${snapshot.data!.bloodGroup}',style: TextStyle(fontSize: myWidth/20));
                        }else{
                          return Shimmer.fromColors(child: Text('Blood Group',style: TextStyle(fontSize: myWidth/20)), baseColor: Colors.grey, highlightColor: Colors.white);
                        }
                      },
                    ),
                    Text('Blood Group',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: myHeight/30,),
                    FutureBuilder<Placemark>(
                      future: getLocation(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Text('${snapshot.data!.locality}',style: TextStyle(fontSize: myWidth/20));
                        }else{
                          return Shimmer.fromColors(child: Text('Your Location',style: TextStyle(fontSize: myWidth/20)), baseColor: Colors.grey, highlightColor: Colors.white);
                        }
                      },
                    ),
                    Text('Pakistan',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: myHeight/30,),
                    FutureBuilder<User>(
                      future: getUser(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Text('${snapshot.data!.email}',style: TextStyle(fontSize: myWidth/20));
                        }else{
                        return Shimmer.fromColors(child: Text('Your Email',style: TextStyle(fontSize: myWidth/20)), baseColor: Colors.grey, highlightColor: Colors.white);
                        }
                      },
                    ),
                    Text('Email',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: myHeight/30,),
                    FutureBuilder<User>(
                      future: getUser(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return Text('${snapshot.data!.number}',style: TextStyle(fontSize: myWidth/20));
                        }else{
                          return Shimmer.fromColors(child: Text('Contact',style: TextStyle(fontSize: myWidth/20)), baseColor: Colors.grey, highlightColor: Colors.white);
                        }
                      },
                    ),
                    Text('Contact No:-',style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
              SizedBox(height: myHeight/20,),
              Container(
                height: myHeight/10,
                width: myWidth,
                margin: EdgeInsets.only(left: myWidth/30,right: myWidth/30),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: myWidth/30),
                        child: Text('Available to donate',style: TextStyle(fontSize: myWidth/20),),
                      ),
                      ToggleSwitch(
                        customWidths: [70.0, 50.0],
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.cyan], [Colors.redAccent]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        labels: ['YES', 'No'],
                        initialLabelIndex: toggle,
                        onToggle: (index) async{
                            if(index == 0){
                              if(toggle == 0){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are Aready Available for Donate'),backgroundColor: Color(CustomColors.PRIMARY_COLOR),));
                              }else{
                                toggle = index!;
                                toggleShared!.setInt('toggle', index);
                                getUser().then((userValue)async{
                                  print('i is ${userValue.sId}');
                                  setAvaibility(userValue.sId!, web3client!).then((value)async{
                                    await uploadDonorImages(userValue.sId!,context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Now Available for Donate'),backgroundColor: Color(CustomColors.PRIMARY_COLOR),));
                                  });
                                });
                              }
                            }else{
                              if(toggle == 1){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are Already not Available for Donate'),backgroundColor: Color(CustomColors.PRIMARY_COLOR),));
                              }else{
                                toggle = index!;
                                toggleShared!.setInt('toggle', index);
                                getUser().then((userValue)async{
                                  removeAvailbility(userValue.sId!, web3client!).then((value)async{
                                    await deleteActiveDonor(userValue.sId!, context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not Available for donate'),backgroundColor: Color(CustomColors.PRIMARY_COLOR)));
                                  });
                                });
                              }
                            }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<User> getUser()async{

    SharedPreferences shared = await SharedPreferences.getInstance();
    String? user = shared.getString('user');
    Map<String,dynamic> userMap = jsonDecode(user!);
    User userObj = User.fromJson(userMap);

    return userObj;
  }

  Future<Placemark> getLocation()async{

    Position position = await checkLocation();
    List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);

    return placeMark[0];
  }

  void preference()async{

    toggleShared = await SharedPreferences.getInstance();

    if(toggleShared!.getInt('toggle') == null){
      toggleShared!.setInt('toggle', 0);
      setState(() {
        toggle = 0;
        getUser().then((userValue)async{
          setAvaibility(userValue.sId!, web3client!).then((value)async{
            dynamic i = await uploadDonorImages(userValue.sId!,context);
            print('i is ${i}');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Now Available for Donate'),backgroundColor: Color(CustomColors.PRIMARY_COLOR),));
          });
        });
      });
    }else{
      if(toggleShared!.getInt('toggle') == 0){
        setState(() {
          toggle = 0;
        });
      }else{
        setState(() {
          toggle = 1;
        });
      }
    }

  }

}