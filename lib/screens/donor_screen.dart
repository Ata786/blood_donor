import 'package:flutter/material.dart';
import '../colors.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({Key? key}) : super(key: key);

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {


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
                          child: ListView.builder(
                            itemCount: 10,
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
                                            child: CircleAvatar(child: Image.asset('assets/man.png',scale: myWidth/120,),radius: myWidth / 14,backgroundColor: Colors.green,),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Ata-Ur-Rehman',style: TextStyle(fontSize: myWidth/18),),
                                            Text('Ahmed Pur East',style: TextStyle(fontSize: myWidth/25),),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right:myWidth/20 ),
                                          child: Text('AB+',style: TextStyle(fontSize: (myWidth / 1.1)/30,color: Color(CustomColors.PRIMARY_COLOR))),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
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
}