import 'dart:async';
import 'dart:convert';
import 'package:blood_bank/colors.dart';
import 'package:blood_bank/logic/contract_linking.dart';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:blood_bank/model/Request.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({Key? key}) : super(key: key);

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {

  Client? httpClient;
  Web3Client? web3client;
  List<dynamic>? list;
  List<SnapShot>? images;
  Timer? timer;
  bool show = true;

  String rpcUrl = 'http://192.168.100.36:7545';

  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
    // TODO: implement initState
    timer = Timer.periodic(Duration(milliseconds: 400),
            (timer) {
      setState(() {
       show = !show;
      });
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: FutureBuilder<List<dynamic>>(
          future: requests(),
            builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  var reverseList = snapshot.data!.reversed.toList();
                  var reverseImages = images!.reversed.toList();
                  return InkWell(
                    onTap: ()async{
                      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                      String? user = sharedPreferences.getString('user');
                      Map<String,dynamic> userMap = jsonDecode(user!);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                        ),
                          builder: (context){
                          return Container(
                            height: myHeight/1.2,
                            width: myWidth,
                            child:  Column(
                              children: [
                                Container(
                                  height: (myHeight/1.2)/1.8,
                                  width: myWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25.0),
                                      topLeft: Radius.circular(25.0)
                                    ),
                                    child: Image.network(reverseImages[index].screenShot,fit: BoxFit.cover,),
                                  )
                                ),
                                SizedBox(height: (myHeight/1.2)/40,),
                                CircleAvatar(
                                  radius: myWidth/10,
                                  backgroundImage: NetworkImage(userMap['image']),
                                ),
                                SizedBox(height: (myHeight/1.2)/50,),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: myWidth/20,),
                                      Text('Patient Name :-',style: TextStyle(fontWeight: FontWeight.w900),),
                                      Text('   ${reverseList[index][1]}')
                                    ],
                                  ),
                                ),
                                SizedBox(height: (myHeight/1.2)/50,),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: myWidth/20,),
                                      Text('Location :-',style: TextStyle(fontWeight: FontWeight.w900),),
                                      Text('            ${reverseList[index][5]}')
                                    ],
                                  ),
                                ),
                                SizedBox(height: (myHeight/1.2)/50,),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: myWidth/20,),
                                      Text('Contact No :-',style: TextStyle(fontWeight: FontWeight.w900),),
                                      Text('       ${reverseList[index][2]}')
                                    ],
                                  ),
                                ),
                                SizedBox(height: (myHeight/1.2)/50,),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: myWidth/20,),
                                      Text('Blood Group :-',style: TextStyle(fontWeight: FontWeight.w900),),
                                      Text('     ${reverseList[index][4]}')
                                    ],
                                  ),
                                ),
                                SizedBox(height: (myHeight/1.2)/60,),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: myWidth/20,),
                                      Text('Reason :-',style: TextStyle(fontWeight: FontWeight.w900),),
                                      Flexible(child: Padding(
                                          padding: EdgeInsets.only(left: 20,right: 5),
                                          child: Text('        ${reverseList[index][3]}')))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                          },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: myWidth/40),
                      // height: myHeight/2,
                      width: myWidth,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: (myHeight/2)/20,),
                            Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.red,),
                                Text('${reverseList[index][5]}'),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Text(
                                    'Pending',
                                    style: show ? TextStyle(color: Colors.red) : TextStyle(color: Colors.transparent),),
                                ),
                              ],
                            ),
                            SizedBox(height: (myHeight/2)/20,),
                            Padding(
                              padding: EdgeInsets.only(left: myWidth/30),
                              child: Container(

                                  child: Text('${reverseList[index][3]}',style: TextStyle(fontSize: myWidth/25),)),
                            ),
                            SizedBox(height: (myHeight/2)/20,),
                            Container(
                              height: (myHeight/2)/2,
                              width: myWidth,
                              child: Image.network('${reverseImages[index].screenShot}',fit: BoxFit.cover,)
                            ),
                            SizedBox(height: (myHeight/2)/20,),
                            Text('   Request Date :- ${reverseImages[index].date}'),
                            SizedBox(height: (myHeight/2)/20,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else if(snapshot.hasError){
              return Center(child: Text('Error is ${snapshot.error}'),);
            }else{
              return Center(child: CircularProgressIndicator(color: Color(CustomColors.PRIMARY_COLOR),),);
            }
            }
        ),
      ),
    ));
  }

  Future<List<dynamic>> requests()async{

    SharedPreferences shared = await SharedPreferences.getInstance();
      String? user = shared.getString('user');
      Map<String,dynamic> userMap = jsonDecode(user!);

      List<dynamic> requests = await getFunction('getUserRequests', web3client!, [userMap['_id']]);
      var response = await getUserSnapShot(userMap['_id'], context);
      List<dynamic> obj = jsonDecode(response);

      images = obj.map((e) => SnapShot(id: '', screenShot: e['screenShot'], location: '', reason: '', date: e['date'])).toList();
      

    return requests[0];
  }

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }


}