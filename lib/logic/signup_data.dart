import 'dart:convert';
import 'dart:io';
import 'package:blood_bank/logic/contract_linking.dart';
import 'package:blood_bank/states/already_exist.dart';
import 'package:blood_bank/states/loginState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import '../model/User.dart';

final existProvider = StateNotifierProvider<ExistProvider,ExistState>((ref) => ExistProvider(value: ''));
final loginProvider = StateNotifierProvider<LoginProvider,LoginState>((ref) => LoginProvider(found: ''));
final passwordProvider = StateNotifierProvider<PasswordProvider,LoginState>((ref) => PasswordProvider(passIncorrect: ''));


void signUpUser(File image,String name,String email,String password,String type,String number,String bloodGroup,BuildContext context,WidgetRef ref,Web3Client web3client)async{

  // User user = User(image: image,name: name,email: email,password: password,type: type);

  var stream = new http.ByteStream(image.openRead());
  stream.cast();
  // get file length
  var length = await image.length();

  var request = http.MultipartRequest('POST',Uri.parse('http://192.168.100.36:5000/api/register'));
  request.fields['name'] = name;
  request.fields['email'] = email;
  request.fields['password'] = password;
  request.fields['type'] = type;
  
  // var multipartFile = await http.MultipartFile.fromPath('image', image!);
  var multiPartFile = http.MultipartFile('image',stream,length,filename: image.path);

  request.files.add(multiPartFile);

  var response = await request.send();

  if(response.statusCode == 200){

    final data = await response.stream.bytesToString();
    Map<String,dynamic> mapData = jsonDecode(data);
    User user = User.fromJson(mapData);
    User userObj = User(sId: user.sId,name: user.name,email: user.email,image: user.image,type: user.type,isLogin: true);

    setUserData(userObj,number,bloodGroup,context,ref,web3client);

  }else if(response.statusCode == 409){
    ref.read(existProvider.notifier).setValue('User Already Exist');
  }else{
    print('error');
  }

}

void setUserData(User user,String number,String bloodGroup,BuildContext context,WidgetRef ref,Web3Client web3client)async{


  SharedPreferences preferences = await SharedPreferences.getInstance();

  Map<String,dynamic> userMap = user.toJson();
  String userJson = jsonEncode(userMap);
  preferences.setString('user', userJson);

  ref.read(existProvider.notifier).setValue('');
  SnackBar snackBar = SnackBar(content: Text('Successfully Created'),backgroundColor: Color(CustomColors.PRIMARY_COLOR),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  if(user.type == 'Donor'){
    Navigator.pushNamedAndRemoveUntil(context, Routers.HOME_SCREEN, (route) => false);
  }else if(user.type == 'Receiver'){
     setUser(1, user.sId!, user.name!, user.email!, number, bloodGroup, web3client);
     Navigator.pushNamedAndRemoveUntil(context, Routers.RECEIVER_SCREEN, (route) => false);
  }else{
    print('no');
  }

}

void loginUser(String email,String password,String type,WidgetRef ref,BuildContext context)async{

  User login = User(email: email,password: password,type: type);
  String userJson = jsonEncode(login);

  var response = await http.post(Uri.parse('http://192.168.100.36:5000/api/login'),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
    body: userJson,
  );

  if(response.statusCode == 200){

    Map<String,dynamic> data = jsonDecode(response.body);
    User user = User.fromJson(data);
    User userObj = User(sId: user.sId,name: user.name,email: user.email,image: user.image,type: user.type,isLogin: true);

    SharedPreferences shared = await SharedPreferences.getInstance();
    Map<String,dynamic> userJson = userObj.toJson();
    String json = jsonEncode(userJson);

    shared.setString('user', json);

    if(user.type == 'Donor'){
      Navigator.pushNamedAndRemoveUntil(context, Routers.HOME_SCREEN, (route) => false);
    }else if(user.type == 'Receiver'){
      Navigator.pushNamedAndRemoveUntil(context, Routers.RECEIVER_SCREEN, (route) => false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Not Found')));
    }


    ref.read(loginProvider.notifier).notFound('');
    ref.read(passwordProvider.notifier).notPassword('');


  }else if(response.statusCode == 400){
    ref.read(loginProvider.notifier).notFound('userNotFound');
  }else if(response.statusCode == 409){
    ref.read(passwordProvider.notifier).notPassword('Password Incorrect');
  }else{
    print('error');
  }
  
}
