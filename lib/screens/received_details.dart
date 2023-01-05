import 'package:blood_bank/colors.dart';
import 'package:blood_bank/logic/snapshot_image.dart';
import 'package:flutter/material.dart';

import '../model/Received_details.dart';

class ReceivedDetails extends StatefulWidget {
  const ReceivedDetails({Key? key}) : super(key: key);

  @override
  State<ReceivedDetails> createState() => _ReceivedDetailsState();
}

class _ReceivedDetailsState extends State<ReceivedDetails> {

  int value = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final data = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    print('data is ${data['donorId']} and ${data['receiverId']}');

    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: myHeight/20),
              Text('Enter Donor Data',style: TextStyle(fontSize: myWidth/15)),
              SizedBox(height: myHeight/20),
              Padding(
                padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Write Name of Donor?',style: TextStyle(fontSize: myWidth/20),),
                        SizedBox(height: myHeight/100),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: 'Donor Name',
                              hintText: 'Donor Name',
                              helperText: '',
                              border: OutlineInputBorder()
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
                        Text('Write Number of Donor?',style: TextStyle(fontSize: myWidth/20),),
                        SizedBox(height: myHeight/100),
                        TextField(
                          controller: numberController,
                          decoration: InputDecoration(
                              labelText: 'Donor Number',
                              hintText: 'Donor Number',
                              helperText: '',
                              border: OutlineInputBorder()
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
                        Text('At which hospital you received blood?',style: TextStyle(fontSize: myWidth/20),),
                        SizedBox(height: myHeight/100),
                        TextField(
                          controller: hospitalController,
                          decoration: InputDecoration(
                            labelText: 'Hospital Name',
                            hintText: 'Hospital Name',
                              helperText: '',
                              border: OutlineInputBorder()
                          ),
                        ),
                      ],
                    )
                ),
              ),
              SizedBox(height: myHeight/50),
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child:Padding(
                            padding: EdgeInsets.only(left: myWidth/20),
                            child: Text('Quantity of bottles you received?',style: TextStyle(fontSize: myWidth/25),))),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(onPressed: (){
                                setState(() {
                                  if(value >= 0){
                                    value++;
                                  }else{
                                    value = 0;
                                  }
                                });
                              },
                                  child: Center(child: Icon(Icons.add),),
                              style: ElevatedButton.styleFrom(backgroundColor: Color(CustomColors.PRIMARY_COLOR),
                              shape: CircleBorder()),
                              ),
                            ),
                            Expanded(child: Center(child: Text('${value}',style: TextStyle(fontSize: myWidth/20),))),
                            Expanded(
                              child: ElevatedButton(onPressed: (){
                                setState(() {
                                  if(value == 0){
                                    value = 0;
                                  }else{
                                    value--;
                                  }
                                });
                              },
                                child: Center(child: Icon(Icons.remove),),
                                style: ElevatedButton.styleFrom(backgroundColor: Color(CustomColors.PRIMARY_COLOR),
                                    shape: CircleBorder()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height:myHeight/7),
              Container(
                height: myHeight/20,
                width: myWidth/1.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color:Color(CustomColors.PRIMARY_COLOR)),
                  ),
                  onPressed: ()async{
                    ReceivedDetail receive = ReceivedDetail(donorId: data['donorId'],receiverId: data['receiverId'],name: nameController.text,number: numberController.text,hospitalName: hospitalController.text,quantity: value.toString());
                    sendReceiverDetails(receive, context).then((value){
                      Navigator.of(context).pop();
                    });

                  },
                  child: Text('Send Detail',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR)),),),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
