import 'dart:convert';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:blood_bank/logic/your_location.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import '../colors.dart';
import '../logic/contract_linking.dart';
import '../model/Request.dart';
import '../model/User.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Client? httpClient;
  Web3Client? web3client;

  String rpcUrl = 'http://192.168.100.36:7545';
  List<SnapShot>? images;

  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
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
                              child: FutureBuilder<User>(
                                future: getUser(),
                                builder: (context,snapshot){
                                  if(snapshot.hasData){
                                    return CircleAvatar(
                                      backgroundImage: NetworkImage('${snapshot.data!.image}'),radius: myWidth / 12,backgroundColor: Colors.white,);
                                  }else{
                                  return CircleAvatar(
                                  child: Image.asset('assets/man.png'),
                                  radius: myWidth / 12,backgroundColor: Colors.white,);
                                  }
                                },
                              )
                            ),
                          ),
                          SizedBox(width: myWidth / 20,),
                          FutureBuilder<User>(
                            future: getUser(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data!.name}',style: TextStyle(color: Colors.white,fontSize: myWidth / 20),),
                                      Row(children: [
                                        Icon(Icons.location_on,color: Colors.white,size: myWidth/35,),
                                        FutureBuilder<Placemark>(
                                          future: getLocation(),
                                            builder: (context,snapshot){
                                              if(snapshot.hasData){
                                                return Text('${snapshot.data!.locality}',style: TextStyle(color: Colors.white,fontSize: myWidth / 35),);
                                              }else{
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey,
                                                    highlightColor: Colors.white,
                                                    child: Text('Your Location',style: TextStyle(color: Colors.white,fontSize: myWidth / 35),));
                                              }
                                      },)
                                      ],)
                                    ],
                                  );
                                }else{
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.white,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Your Name',style: TextStyle(color: Colors.white,fontSize: myWidth / 20),),
                                        Row(children: [
                                          Icon(Icons.location_on,color: Colors.white,size: myWidth/35,),
                                          Text('Location',style: TextStyle(color: Colors.white,fontSize: myWidth / 35),),
                                        ],)
                                      ],
                                    ),
                                  );
                                }
                              }
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
                      height: myHeight/1.2,
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
                                            FutureBuilder<User>(
                                              future: getUser(),
                                                builder: (context,snapshot){
                                                  if(snapshot.hasData){
                                                    return Text('${snapshot.data!.bloodGroup}',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR)),);
                                                  }else{
                                                    return Shimmer.fromColors(child: Text('Blood Group',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR)),),
                                                        baseColor: Colors.grey, highlightColor: Colors.white);
                                                  }
                                                },
                                                ),
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
                                  InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, Routers.DONOR_REQUESTS);
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
                                            Image.asset('assets/pulse.png',scale: (myWidth/4) / 25,),
                                            Text('Requests',)
                                          ],
                                        ),
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
                              child: Container(
                                height: myHeight/3,
                                width: myWidth,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Active Donors',style: TextStyle(fontSize: myHeight / 40),)),
                                    Expanded(
                                        child: StreamBuilder(
                                          stream: getAvailableDonors(),
                                          builder: (context,snapshot){
                                            if(snapshot.hasData){
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapshot.data.length,
                                                  itemBuilder: (context,index){
                                                    return Container(
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
                                                                              Text('${snapshot.data[index][1]}',style: TextStyle(fontSize:(myWidth / 1.1)/15 ),),
                                                                              Text('${snapshot.data[index][2]}',style: TextStyle(fontSize: (myWidth / 1.1)/30,)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(right:(myWidth / 1.1)/20 ),
                                                                          child: Text('${snapshot.data[index][4]}',style: TextStyle(fontSize: (myWidth / 1.1)/30,color: Color(CustomColors.PRIMARY_COLOR))),
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
                                                                  child: CircleAvatar(backgroundImage: NetworkImage('${images![index].screenShot}') ,radius: myWidth / 17,backgroundColor: Colors.green,),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }else{
                                              return Center(child: CircularProgressIndicator(color: Color(CustomColors.PRIMARY_COLOR),));
                                            }
                                          },
                                        ),
                                    ),
                                  ],
                                ),
                              )
                          ),
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
                   Navigator.pushNamed(context,Routers.PROFILE_SCREEN).then((value){
                     setState(() {

                     });
                   });
                 },
                 child: ListTile(title: Text('Profile'),leading: Icon(Icons.supervisor_account,color: Color(CustomColors.PRIMARY_COLOR),),)),
             Divider(),
             InkWell(
                 onTap: (){
                   Navigator.pop(context);
                   Navigator.pushNamed(context, Routers.DONOR_REQUESTS);
                 },
                 child: ListTile(title: Text('Blood Request'),leading: Icon(Icons.bloodtype_outlined,color: Color(CustomColors.PRIMARY_COLOR)),)),
             Divider(),
             InkWell(
                 onTap: ()async{
                   SharedPreferences shared = await SharedPreferences.getInstance();
                   shared.remove('user');
                   Navigator.pushNamedAndRemoveUntil(context, Routers.SIGN_IN_SCREEN, (route) => false);
                 },
                 child: ListTile(title: Text('Log Out'),leading: Icon(Icons.logout,color: Color(CustomColors.PRIMARY_COLOR)),)),
             Divider(),
           ],
         )
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

  Stream getAvailableDonors()async*{

    List<dynamic> list = await getFunction('getAvailableDonors',web3client!,[]);
    var response = await getActiveDonorImages(context);
    List<dynamic> listMap = jsonDecode(response);
    images = listMap.map((e) => SnapShot(id: '', screenShot: e['images'], location: '', reason: '', date: '')).toList();
    yield list[0];
  }

}

