import 'package:blood_bank/logic/contract_linking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: MyApp()));

  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(CustomColors.PRIMARY_COLOR),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(CustomColors.PRIMARY_COLOR)
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routers.generateRoutes,
      initialRoute: Routers.SPLASH_SCREEN,
    );
  }
}