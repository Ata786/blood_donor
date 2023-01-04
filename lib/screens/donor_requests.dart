import 'dart:convert';
import 'package:blood_bank/colors.dart';
import 'package:blood_bank/logic/contract_linking.dart';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:blood_bank/model/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../Pages.dart';

class DonorRequests extends StatefulWidget {
  const DonorRequests({Key? key}) : super(key: key);

  @override
  State<DonorRequests> createState() => _DonorRequestsState();
}

class _DonorRequestsState extends State<DonorRequests> {

  Client? httpClient;
  Web3Client? web3client;
  List<SnapShot>? images;
  List<SnapShot>? requestImages;

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
    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: StreamBuilder<dynamic>(
          stream: getRequest(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, Routers.REQUEST_DETAIL,arguments: {'requestData': snapshot.data[index],'image': images![index].screenShot,'requestImage':requestImages![index].screenShot});
                    },
                    child: Container(
                      width: myWidth,
                      margin: EdgeInsets.only(left: myWidth/50,right: myWidth/50),
                      child: Card(
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: myHeight/50,),
                            Padding(
                              padding: EdgeInsets.only(left: myWidth/20),
                              child: Row(
                                children: [
                                  CircleAvatar(backgroundImage: NetworkImage('${requestImages![index].screenShot}'),radius: myHeight/37,),
                                  SizedBox(width: myWidth/40,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${snapshot.data[index][1]}',style: TextStyle(fontSize: myWidth/23),),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,color: Colors.red,size: myWidth/25,),
                                          Text('${snapshot.data[index][6]}',style: TextStyle(fontSize: myWidth/30),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: myHeight/100,),
                            Padding(
                                padding: EdgeInsets.only(left: myWidth/30,right: myWidth/30),
                                child: Text('${snapshot.data[index][4]}')),
                            SizedBox(height: myHeight/80,),
                            Container(
                              height: myHeight/4,
                              width: myWidth,
                              child: Image.network('${images![index].screenShot}',fit: BoxFit.cover,),
                            ),
                            SizedBox(height: myHeight/50,),
                            Container(
                              height: myHeight/20,
                              width: myWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: InkWell(
                                        onTap: (){

                                        },
                                        child: Container(
                                    child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.notifications),Text('Notify')],),
                                    ),
                                  ),
                                      )
                                  ),
                                  Container(height: myHeight/20,width: 1,color: Colors.black12,),
                                  Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          UrlLauncher.launchUrl(Uri.parse('tel:${snapshot.data[index][3]}'));
                                        },
                                        child: Container(
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.call,color: Colors.green,
                                                ),Text(
                                                  'Call',style: TextStyle(
                                                    color: Colors.green),
                                                )],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }else{
              return Center(child: CircularProgressIndicator(color: Color(CustomColors.PRIMARY_COLOR),),);
            }
          },
        )
      ),
    ));
  }

  Stream getRequest()async*{
    var res = await getFunction('getAllRequest', web3client!, []);
    var request = await getRequestImages(context);
    List<dynamic> requestList = jsonDecode(request);
    var response = await getAllSnapShots(context);
    List<dynamic> snapShots = jsonDecode(response);
    requestImages = requestList.map((e) => SnapShot(id: '', screenShot: e['image'], location: '', reason: '', date: '')).toList();
    images = snapShots.map((e) => SnapShot(id: '', screenShot: e['screenShot'], location: '', reason: '', date: '')).toList();

    yield res[0];
  }

}
