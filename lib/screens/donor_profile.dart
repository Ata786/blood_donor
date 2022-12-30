import 'package:flutter/material.dart';
import '../Pages.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({Key? key}) : super(key: key);

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Center(child: Text('Donor Profile'),),
        ),
      ),
    );
  }
}