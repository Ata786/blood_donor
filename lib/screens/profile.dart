import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Pages.dart';
import '../colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
                      child: CircleAvatar(child: Image.asset('assets/man.png',scale: myWidth/150,),radius: myWidth / 10,backgroundColor: Colors.green,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: myWidth/30),
                    child: Text('Ata-Ur-Rehman',style: TextStyle(fontSize: myWidth / 20),),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: myWidth/20,top: myWidth/10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AB+',style: TextStyle(fontSize: myWidth/20)),
                    Text('Blood Group',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: myHeight/30,),
                    Text('20-10-2022',style: TextStyle(fontSize: myWidth/20)),
                    Text('Last Blood',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: myHeight/30,),
                    Text('Ahmed pur East',style: TextStyle(fontSize: myWidth/20)),
                    Text('Pakistan',style: TextStyle(color: Colors.grey),),
                    SizedBox(height: myHeight/30,),
                    Text('ata@gmail.com',style: TextStyle(fontSize: myWidth/20)),
                    Text('Email',style: TextStyle(color: Colors.grey),),
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
                        onToggle: (index) {

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
}