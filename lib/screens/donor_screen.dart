import 'dart:convert';

import 'package:blood_bank/logic/contract_linking.dart';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:blood_bank/model/Request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../colors.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({Key? key}) : super(key: key);

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {

  Client? httpClient;
  Web3Client? web3client;
  List<SnapShot>? imagesList;

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
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: myHeight / 1.04,
                  width: myWidth,
                  child: Stack(
                    children: [
                      Container(
                        height: myHeight / 5,
                        width: myWidth,
                        color: Color(CustomColors.PRIMARY_COLOR),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: myHeight / 20,
                        child: Container(
                          margin: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                          height: myHeight / 3.5,
                          width: myWidth / 1.3,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: myHeight/4.5,
                                  width: myWidth/1.3,
                                  child: Card(
                                    elevation: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Image.asset('assets/hero.png',scale: 3,),
                              ),
                              Positioned(
                                  top: (myHeight/3.5)/1.4,
                                  child: Text('You are real heroes',style: TextStyle(fontSize: (myHeight/3.5)/15,color: Color(CustomColors.PRIMARY_COLOR),fontWeight: FontWeight.bold))),
                              Positioned(
                                  top: (myHeight/3.5)/1.2,
                                  child: Text('You are top donors in Pakistan',style: TextStyle(fontSize: (myHeight/3.5)/15,color: Colors.grey))),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: myHeight/2.6,
                          left: myWidth / 20,
                          child: Text('Top Donors',style: TextStyle(fontSize: myWidth/17),)),
                      Positioned(
                        top: myHeight/2.3,
                        child: Container(
                          height: myHeight/1.9,
                          width: myWidth,
                          child: FutureBuilder<dynamic>(
                            future: getDonors(),
                            builder: (context,snapshot){
                              if(snapshot.hasData){
                                return  ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context,index){
                                      return Container(
                                        margin: EdgeInsets.only(top: (myHeight/1.9)/100,left: myWidth/20,right: myWidth/20),
                                        height: (myHeight/1.9)/5,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:EdgeInsets.only(left: myWidth/20),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  child: CircleAvatar(
                                                  backgroundImage: NetworkImage('${imagesList![index].screenShot}'),radius: myWidth / 14,backgroundColor: Colors.green,),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('${snapshot.data[index][1]}',style: TextStyle(fontSize: myWidth/18),),
                                                  Text('${snapshot.data[index][2]}',style: TextStyle(fontSize: myWidth/25),),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right:myWidth/20 ),
                                                child: Text('${snapshot.data[index][4]}',style: TextStyle(fontSize: (myWidth / 1.1)/30,color: Color(CustomColors.PRIMARY_COLOR))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }else{
                                return Center(child: CircularProgressIndicator(),);
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> getDonors()async{
    List<dynamic> donors = await getFunction('getAllDonors', web3client!, []);
    var response = await getDonorImages(context);
    List<dynamic> images = jsonDecode(response);
    imagesList = images.map((e) => SnapShot(id: '', screenShot: e['image'], location: '', reason: '', date: '')).toList();
    return donors[0];
  }


}