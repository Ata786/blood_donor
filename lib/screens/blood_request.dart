import 'dart:convert';
import 'dart:io';

import 'package:blood_bank/colors.dart';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import '../logic/contract_linking.dart';
import '../model/User.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  List<String> menuItems = ['Select Group','A+','A-','B+','B-','O+','O-','AB+','AB-'];
  String itemValue = 'Select Group';
  String data = 'Set Location';
  String? receiverId,contactNumber;
  Map<String,dynamic> location = {};
  String? lat;
  File? locationFile;
  String? userId;

  Client? httpClient;
  Web3Client? web3client;

  String rpcUrl = 'http://192.168.100.36:7545';


  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
    // TODO: implement initState
    super.initState();
    getReceiverData();
  }

  @override
  Widget build(BuildContext context) {


    if(lat == null){
      data = 'Set Location';
    }else{
      data = lat!;
    }

    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: myHeight,
          width: myWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: myHeight/20),
                Text('Enter Patient Data',style: TextStyle(fontSize: myWidth/15)),
                SizedBox(height: myHeight/20),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Write Name of Patient?',style: TextStyle(fontSize: myWidth/20),),
                        SizedBox(height: myHeight/100),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Patient Name',
                              hintText: 'Patient Name',
                              border: OutlineInputBorder()
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                SizedBox(height: myHeight/30),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('At which hospital you need blood?',style: TextStyle(fontSize: myWidth/20),),
                          SizedBox(height: myHeight/100),
                          TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                                hintText: data,
                                helperText: '',
                                border: OutlineInputBorder()
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.location_on,color: Colors.red,),
                                InkWell(
                                    onTap: ()async{
                                      final dynamic response = await Navigator.of(context).pushNamed(Routers.RECEIVER_LOCATION_SCREEN);
                                      lat = response['address'];
                                      userId = response['id'];
                                      locationFile = response['screenShot'];
                                    },
                                    child: Text('Get place Location'))
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: myHeight/30),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Which type of blood you want?',style: TextStyle(fontSize: myWidth/20),),
                          SizedBox(height: myHeight/100),
                          Container(
                            height: myHeight / 20,
                            width: myWidth / 1.2,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.black45)
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: itemValue,
                                items: menuItems.map(dropDownItem).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    itemValue =  value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: myHeight/50),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("What's the reason of this request?",style: TextStyle(fontSize: myWidth/20),),
                          SizedBox(height: myHeight/100),
                          TextField(
                            controller: reasonController,
                            maxLength: 100,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: "Reason of this request...",
                                border: OutlineInputBorder()
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                SizedBox(height: myHeight/50),
                Container(
                  height: myHeight/20,
                  width: myWidth/1.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color:Color(CustomColors.PRIMARY_COLOR)),
                    ),
                    onPressed: ()async{
                      uploadSnapShot(userId!, locationFile!, context).then((value){
                        setRequest(receiverId!,nameController.text,contactNumber!,reasonController.text,itemValue,lat!,web3client!).then((value){
                          Navigator.pushReplacementNamed(context, Routers.ALL_REQUESTS);
                        });
                      });
                    },
                      child: Text('Send Request',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR)),),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> dropDownItem(String item){
    return DropdownMenuItem(
        value: item,
        child: Text(item)
    );
  }

  void getReceiverData()async{

    SharedPreferences shared = await SharedPreferences.getInstance();
    String? user = shared.getString('user');
    Map<String,dynamic> userMap = jsonDecode(user!);
    User userObj = User.fromJson(userMap);

    receiverId = userObj.sId;
    contactNumber = userObj.number;

  }

}