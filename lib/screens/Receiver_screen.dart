import 'dart:convert';
import 'package:blood_bank/logic/your_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import '../colors.dart';
import '../model/User.dart';

class ReceiverScreen extends ConsumerStatefulWidget {
  const ReceiverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends ConsumerState<ReceiverScreen> with TickerProviderStateMixin {


  final scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleSignIn goolgeSignIn = GoogleSignIn();
  Client? httpClient;
  Web3Client? web3client;

  String rpcUrl = 'http://192.168.100.36:7545';

  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: Container(
          height: myHeight,
          width: myWidth,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                centerTitle: false,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: myWidth/30),
                    child: Builder(
                      builder: (context){
                        return  IconButton(
                            onPressed: (){
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: Icon(Icons.notification_important));
                      },
                    )
                  )
                ],
                backgroundColor: Color(CustomColors.PRIMARY_COLOR),
                title:Padding(
                  padding: EdgeInsets.only(left: myWidth/10),
                  child: Text('Donate Blood'),
                ),
                automaticallyImplyLeading: false,
                expandedHeight: myHeight / 4,
                bottom: PreferredSize(
                    child: Container(
                      height: (myHeight / 4)/2.5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: myWidth / 10,),
                          FutureBuilder<User>(
                            future: getReceiverData(),
                            builder: (context,snapshot){
                              if(snapshot.hasData){
                                return Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.image!),radius: myWidth / 12,backgroundColor: Colors.white,),
                                  ),
                                );
                              }else if(snapshot.hasError){
                                return Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: CircleAvatar(child: Image.asset('assets/man.png',height: (myHeight / 4)/4,width: (myHeight / 4)/4,),radius: myWidth / 12,backgroundColor: Colors.white,),
                                  ),
                                );
                              }else{
                                return Shimmer.fromColors(child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: CircleAvatar(child: Image.asset('assets/man.png',height: (myHeight / 4)/4,width: (myHeight / 4)/4,),radius: myWidth / 12,backgroundColor: Colors.white,),
                                  ),
                                ),
                                    baseColor: Colors.white, highlightColor:Colors.grey);
                              }
                            },
                          ),
                          SizedBox(width: myWidth / 50,),
                          Container(
                            height: (myHeight/4) / 4,
                            width: myWidth/2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            FutureBuilder<User>(
                            future: getReceiverData(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return Text(snapshot.data!.name!,style: TextStyle(color: Colors.white,fontSize: myWidth / 20),);
                                }else if(snapshot.hasError){
                                  return Text('Data Error ${snapshot.error}',style: TextStyle(color: Colors.white,fontSize: myWidth / 20),);
                                }else{
                                  return Shimmer.fromColors(child: Text('Receiver Name',style: TextStyle(color: Colors.white,fontSize: myWidth / 20)),
                                      baseColor: Colors.white,
                                      highlightColor: Colors.grey);
                                }
                              }
                          ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,color: Colors.white,),
                                    FutureBuilder<Placemark>(
                                      future: getLocation(),
                                        builder: (context,snapshot){
                                      if(snapshot.hasData){
                                        return Text('${snapshot.data!.country} ${snapshot.data!.locality}',style: TextStyle(color: Colors.white,fontSize: myWidth / 35),);
                                      }else if(snapshot.hasError){
                                        return Text('');
                                      }else{
                                        return Shimmer.fromColors(child: Text('Location'),
                                            baseColor: Colors.grey,
                                            highlightColor: Colors.white
                                        );
                                      }
                                    })
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    preferredSize: Size.fromHeight(100)),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: myHeight/20),
                      Container(
                        height: myHeight / 5,
                        width: myWidth/1.3,
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: (myWidth/1.5)/20),
                                    child: Image.asset('assets/blood_asset.png',height: (myHeight/5)/3,width: myWidth/10,),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: (myWidth/1.5)/15,top: (myWidth/1.5)/20),
                                        child: Text('Request for Blood',style: TextStyle(fontSize: (myWidth/1.5)/15)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: (myWidth/1.5)/20,top: (myWidth/1.5)/30),
                                        child: Text('Find blood donor near your\nlocation and request the needed\nblood typeand its all\nfree of cost'),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: (myHeight/5)/15,),
                              Padding(
                                padding: EdgeInsets.only(left: (myWidth/1.5)/1.3),
                                child: InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, Routers.REQUEST_SCREEN);
                                    },
                                    child: Text(
                                        'Find >',
                                        style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR),fontSize: (myWidth/1.5)/15))),
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: myHeight/30,),
                      Container(
                        height: myHeight / 5,
                        width: myWidth/1.3,
                        child: Card(
                          elevation: 2,
                          child: Row(
                            children: [
                              Container(height: myHeight/5,width: (myWidth/1.3)/4,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: (myWidth/1.5)/20),
                                    child: Image.asset('assets/blood_asset.png',height: (myHeight/5)/3,width: myWidth/10,),
                                  ),
                                ],
                              ),
                              ),
                              Container(height: myHeight/5,width: (myWidth/1.3)/1.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: (myHeight/5)/17,),
                                  Text('Your Blood Requests',style: TextStyle(fontSize: (myWidth/1.5)/15)),
                                  SizedBox(height: (myHeight/5)/20,),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text('Your blood requests for find donor near your location and request the needed blood types and its all free of cost'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: (myWidth/1.3)/4,top: (myHeight/5)/10),
                                    child: InkWell(
                                        onTap: (){
                                          Navigator.pushNamed(context, Routers.ALL_REQUESTS);
                                        },
                                        child: Text('Check Requests',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR,),fontSize: (myWidth/1.3)/18,))),
                                  )
                                ],
                              ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: myHeight/30,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(padding: EdgeInsets.only(left: 20),child: Text('Active Donors',style: TextStyle(fontSize: myWidth/20),),),),
                      SizedBox(height: myHeight/30,),
                      Container(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 20,
                            itemBuilder: (context,index){
                              return Container(
                                margin: EdgeInsets.only(left: myWidth/30,right: myWidth/30),
                                height: myHeight/10,
                                width: myWidth,
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: myWidth/30),
                                        height: (myHeight/10)/1.5,
                                        width: myWidth/7,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(myWidth/50)
                                            ),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage('https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80')
                                            )
                                        ),
                                      ),
                                      SizedBox(width: myWidth/30,),
                                      Container(
                                        width: myWidth/1.8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('ATA-UR-REHMAN',style: TextStyle(fontSize: myWidth/23),),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on),
                                                Text('Location')
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: myWidth/7,
                                        child: Center(child: Text('Active',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900),),),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
        endDrawer: Drawer(
          key: scaffoldKey,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: myHeight/1.3,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: myHeight/50,),
                        Text(
                            'Notifications',
                            style: TextStyle(fontSize: myWidth/15)
                        ),
                      ],
                    ),
                  )
                ),
                Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: ()async{
                    SharedPreferences shared = await SharedPreferences.getInstance();
                    await shared.remove('user');

                    Navigator.pushNamedAndRemoveUntil(context, Routers.SIGN_IN_SCREEN, (route) => false);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: myWidth/4,),
                      Icon(Icons.logout,size: myWidth/15,),
                      SizedBox(width: myWidth/15,),
                      Text('Log out',style: TextStyle(fontSize: myWidth/19),)
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Future<Placemark> getLocation()async{

    Position position = await checkLocation();
    List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);

    return placeMark[0];
  }

  Future<User> getReceiverData()async{

    SharedPreferences shared = await SharedPreferences.getInstance();

    User? userData;
    String? user = shared.getString('user');
    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
    }else{

     Map<String,dynamic> userJson = jsonDecode(user);
     User userObj = User.fromJson(userJson);
    userData = userObj;
    
    }
    return userData!;
  }


}