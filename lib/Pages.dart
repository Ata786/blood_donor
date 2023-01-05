import 'package:blood_bank/screens/Receiver_screen.dart';
import 'package:blood_bank/screens/all_request.dart';
import 'package:blood_bank/screens/blood_request.dart';
import 'package:blood_bank/screens/blood_request_detail.dart';
import 'package:blood_bank/screens/donor_requests.dart';
import 'package:blood_bank/screens/donor_screen.dart';
import 'package:blood_bank/screens/home_screen.dart';
import 'package:blood_bank/screens/profile.dart';
import 'package:blood_bank/screens/received_details.dart';
import 'package:blood_bank/screens/receiver_location.dart';
import 'package:blood_bank/screens/signin_screen.dart';
import 'package:blood_bank/screens/signup_screen.dart';
import 'package:blood_bank/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Routers{

  static const String SPLASH_SCREEN = '/';
  static const String HOME_SCREEN = '/home_page';
  static const String DONOR_SCREEN = '/donor_page';
  static const String DONATES_SCREEN = '/donates_page';
  static const String PROFILE_SCREEN = '/profile_page';
  static const String SIGN_IN_SCREEN = '/signin_page';
  static const String SIGN_UP_PROFILE = '/signup_profile';
  static const String RECEIVER_SCREEN = '/receiver_screen';
  static const String REQUEST_SCREEN = '/request_screen';
  static const String RECEIVER_LOCATION_SCREEN = '/receiver_location_screen';
  static const String ALL_REQUESTS = '/all_requests';
  static const String DONOR_REQUESTS = '/donor_requests';
  static const String REQUEST_DETAIL = '/request_detail';
  static const String RECEIVED_DETAIL = '/received_details';


  static Route<dynamic> generateRoutes(RouteSettings settings){
    switch(settings.name){
      case SPLASH_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => SplashScreen());
        break;
      case HOME_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => HomeScreen());
        break;
      case DONOR_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => DonorScreen());
        break;
      case PROFILE_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => ProfileScreen());
        break;
      case SIGN_UP_PROFILE:
        return MaterialPageRoute(settings: settings,builder: (_) => SignUp());
        break;
      case SIGN_IN_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => SignIn());
        break;
      case RECEIVER_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => ReceiverScreen());
        break;
      case REQUEST_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => RequestScreen());
        break;
      case RECEIVER_LOCATION_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => ReceiverLocation());
        break;
      case ALL_REQUESTS:
        return MaterialPageRoute(settings: settings,builder: (_) => AllRequests());
        break;
      case DONOR_REQUESTS:
        return MaterialPageRoute(settings: settings,builder: (_) => DonorRequests());
        break;
      case REQUEST_DETAIL:
        return MaterialPageRoute(settings: settings,builder: (_) => RequestDetails());
        break;
      case RECEIVED_DETAIL:
        return MaterialPageRoute(settings: settings,builder: (_) => ReceivedDetails());
        break;
      default:
        return MaterialPageRoute(builder: (_)=> MaterialApp(home: Scaffold(body: Center(child: Text('Not Routes Define'),),),));
    }
  }
}