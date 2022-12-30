import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages.dart';
import '../colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: Stack(
          children: [
            Container(
              height: myHeight / 4,
              width: myWidth,
              color: Color(CustomColors.PRIMARY_COLOR),
            ),
            Container(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    expandedHeight: myHeight / 8,
                    toolbarHeight: myHeight/8,
                    title: Padding(
                      padding: EdgeInsets.only(top: myHeight / 50),
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: CircleAvatar(child: Image.asset('assets/man.png',height: myHeight / 10,width: myWidth / 10,),radius: myWidth / 12,backgroundColor: Colors.white,),
                            ),
                          ),
                          SizedBox(width: myWidth / 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ata-Ur-Rehman',style: TextStyle(color: Colors.white,fontSize: myWidth / 20),),
                              Text('Ahmed Pur East',style: TextStyle(color: Colors.white,fontSize: myWidth / 35),),
                            ],
                          )
                        ],
                      ),
                    ),
                    leading: Builder(
                      builder: (context){
                        return IconButton(
                          onPressed: (){
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Image.asset('assets/menu.png'),
                        );
                      },
                    ),
                    leadingWidth: myWidth / 9,
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child:Container(
                      height: myHeight * 1.1,
                      width: myWidth,
                      child: Stack(
                        children: [
                          Positioned(
                            top: myHeight / 40,
                            right: 0,
                            left: 0,
                            child: Container(
                              margin: EdgeInsets.only(left: myWidth / 20,right: myWidth / 20),
                              height: myHeight / 4.5,
                              width: myWidth / 1.2,
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: (myWidth / 1.2) / 1.6,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: (myHeight / 4.5) / 10,),
                                          Text('Become a blood donor',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR,),fontSize: ((myWidth / 1.2) / 1.6) / 13,),),
                                          Text('Donates Directly to people',style: TextStyle(fontSize: ((myWidth / 1.2) / 1.6) / 13,)),
                                          SizedBox(height: (myHeight / 4.5) / 10,),
                                          Text('Easy\nSteps',style: TextStyle(fontSize: ((myWidth / 1.2) / 1.6) / 8,),),
                                          SizedBox(height: (myHeight / 4.5) / 15,),
                                          Text('Become a Donor',style: TextStyle(fontWeight: FontWeight.bold,fontSize: ((myWidth / 1.2) / 1.6) / 13,),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width: (myWidth / 1.2) / 2.5,
                                        child: Image.asset('assets/blood_img.png',scale: 0.5,))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 0,
                            top: myHeight / 3.5,
                            child: Container(
                                margin: EdgeInsets.only(left: myWidth / 20,right: myWidth / 20),
                                height: myHeight / 7,
                                width: myWidth,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: (myHeight/7) / 1.1,
                                        width: myWidth / 2.3,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset('assets/life_saved.png',scale: (myWidth/4) / 25,),
                                            Text('5',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR)),),
                                            Text('Life Saved',style: TextStyle(color: Colors.grey),)
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: (myHeight/7) / 1.1,
                                        width: myWidth / 2.3,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset('assets/blood_group.png',scale: (myWidth/4) / 25,),
                                            Text('B+',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR)),),
                                            Text('Blood Group',style: TextStyle(color: Colors.grey),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 0,
                            top: myHeight / 2.2,
                            child: Container(
                              margin: EdgeInsets.only(left: myWidth / 20,right: myWidth / 20),
                              height: myHeight / 8,
                              width: myWidth,
                              color: Color(CustomColors.GRAY_COLOR),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, Routers.DONOR_SCREEN);
                                    },
                                    child: Container(
                                      height: (myHeight / 8) / 1.1,
                                      width: myWidth / 4,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset('assets/blood_search.png',scale: (myWidth/4) / 25,),
                                            Text('Donors')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, Routers.DONATES_SCREEN);
                                    },
                                    child: Container(
                                      height: (myHeight / 8) / 1.1,
                                      width: myWidth / 4,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset('assets/donates.png',scale: (myWidth/4) / 25,),
                                            Text('Donates',)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: (myHeight / 8) / 1.1,
                                    width: myWidth / 4,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset('assets/pulse.png',scale: (myWidth/4) / 25,),
                                          Text('Requests',)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              left: myWidth / 20,
                              top: myHeight / 1.6,
                              child: Text('Active Donors',style: TextStyle(fontSize: myHeight / 40),)),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: myHeight / 1.5,
                            child: Container(
                              height: myHeight / 2.2,
                              width: myWidth,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                  itemCount: 10,
                                  itemBuilder: (context,index){
                                return InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(context, Routers.DONOR_PROFILE);
                                  },
                                  child: Container(
                                    height: (myHeight/2.2) / 4,
                                    width: myWidth,
                                    child: Card(
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: myWidth / 9,right: myWidth / 25),
                                              height: ((myHeight/2.2) / 4) / 1.5,
                                              width:myWidth / 1.1,
                                              child: Card(
                                                elevation: 2,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(left:(myWidth / 1.1)/9 ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Ata-Ur-Rehman',style: TextStyle(fontSize:(myWidth / 1.1)/15 ),),
                                                          Text('Ahmed Pur East',style: TextStyle(fontSize: (myWidth / 1.1)/30,)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(right:(myWidth / 1.1)/20 ),
                                                      child: Text('AB+',style: TextStyle(fontSize: (myWidth / 1.1)/30,color: Color(CustomColors.PRIMARY_COLOR))),
                                                    ),
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: ((myHeight/2.2) /4) /4.5,
                                            left: myWidth / 20,
                                            child: Container(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(25.0),
                                                child: CircleAvatar(child: Image.asset('assets/man.png',height: myHeight / 30,width: myWidth / 30,),radius: myWidth / 17,backgroundColor: Colors.green,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ],
              )
            ),
          ],
        ),
       drawer: Drawer(
         key: scaffoldKey,
         child: ListView(
           children: [
             DrawerHeader(child: Container(
             child: Image.asset('assets/drawer_icon.png'),
             ),padding: EdgeInsets.all(0),),
             InkWell(
                 onTap: (){
                   Navigator.pop(context);
                   Navigator.pushNamed(context,Routers.PROFILE_SCREEN);
                 },
                 child: ListTile(title: Text('Profile'),leading: Icon(Icons.supervisor_account,color: Color(CustomColors.PRIMARY_COLOR),),)),
             Divider(),
             InkWell(child: ListTile(title: Text('Blood Request'),leading: Icon(Icons.bloodtype_outlined,color: Color(CustomColors.PRIMARY_COLOR)),)),
             Divider(),
           ],
         )
       ),
      ),
    );
  }
}
