import 'package:flutter/material.dart';

import '../Pages.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({Key? key}) : super(key: key);

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: ListView.builder(
          itemCount: 10,
            itemBuilder: (context,index){
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, Routers.MY_REQUEST);
                },
                child: Container(
                  margin: EdgeInsets.only(top: myWidth/40),
                  height: myHeight/2,
                  width: myWidth,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: (myHeight/2)/20,),
                        Row(
                          children: [
                            Icon(Icons.location_on,color: Colors.red,),
                            Text('Location'),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('Pending',style: TextStyle(color: Colors.red),),
                            ),
                          ],
                        ),
                        SizedBox(height: (myHeight/2)/20,),
                        Padding(
                          padding: EdgeInsets.only(left: myWidth/30),
                          child: Container(
                              height: (myHeight/2)/5,
                              child: Text('the quantities, characters, or symbols on which operations are performed by a computer the quantities, characters, or symbols on which operations are performed by a computer',style: TextStyle(fontSize: myWidth/25),)),
                        ),
                        Container(
                          height: (myHeight/2)/2,
                          width: myWidth,
                          child: Image.network('https://cdn.pixabay.com/photo/2022/11/30/13/16/tel-aviv-7626789_960_720.jpg',fit: BoxFit.cover),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
        ),
      ),
    ));
  }
}