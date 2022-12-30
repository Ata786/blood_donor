import 'package:flutter/material.dart';
import '../Pages.dart';

class DonatesScreen extends StatefulWidget {
  const DonatesScreen({Key? key}) : super(key: key);

  @override
  State<DonatesScreen> createState() => _DonatesScreenState();
}

class _DonatesScreenState extends State<DonatesScreen> {

  @override
  void initState() {
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
          height: myHeight,
          width: myWidth,
          child: Center(child: Text('Splash Screen'),),
        ),
      ),
    );
  }
}
