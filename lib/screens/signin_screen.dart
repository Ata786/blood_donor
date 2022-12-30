import 'dart:convert';
import 'dart:io';

import 'package:blood_bank/states/Visible_Password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import '../colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logic/signup_data.dart';
import '../states/RadioState.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}


class _SignInState extends ConsumerState<SignIn> {

  final visibleProvider = StateNotifierProvider<VisibleProvider,VisibleState>((ref) => VisibleProvider(value: ''));
  final radioProvider = StateNotifierProvider<RadioProvider,RadioState>((ref) => RadioProvider(value: 0));

  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();

  Client? httpClient;
  Web3Client? web3client;

  String rpcUrl = 'http://192.168.100.36:7545';

  @override
  void initState() {
    httpClient = Client();
    web3client = Web3Client(rpcUrl, httpClient!);
    // TODO: implement initState
    super.initState();
  }

  FocusNode focusController = FocusNode();
  FocusNode emailFocus = FocusNode();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: myHeight/2.09,
                  width: myWidth,
                  child: Lottie.asset('assets/signup_lottie.json')
              ),
              Padding(
                padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                child: TextField(
                  autofocus: ref.watch(loginProvider).notFound == '' ? false : false,
                  controller: emailController,
                  decoration: InputDecoration(
                    helperText: ref.watch(loginProvider).notFound == '' ? '' : 'User Not Found',
                      helperStyle: TextStyle(
                        color: ref.watch(loginProvider).notFound == '' ? Colors.grey : Colors.red,
                      ),
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      enabledBorder: ref.watch(loginProvider).notFound == '' ? OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                      )
                          : OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myWidth/30)),
                        borderSide: BorderSide(color: Colors.red)
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                      ),
                      prefixIcon: Icon(Icons.email)
                  ),
                ),
              ),
              SizedBox(height: myHeight/50,),
              Padding(
                padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: ref.watch(visibleProvider).value == '' ? true : false,
                  decoration: InputDecoration(
                    helperText: ref.watch(passwordProvider).incorrect == '' ? '' : 'Password Incorrect',
                      helperStyle: TextStyle(
                        color: ref.watch(passwordProvider).incorrect == '' ? Colors.grey : Colors.red,
                      ),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      enabledBorder: ref.watch(passwordProvider).incorrect == '' ? OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                      )
                          : OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myWidth/30)),
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                      ),
                      prefixIcon:  Icon(Icons.lock),
                      suffixIcon: IconButton(
                          onPressed: (){
                            if(ref.watch(visibleProvider).value == ''){
                              ref.read(visibleProvider.notifier).setVisibility('visible');
                            }else{
                              ref.read(visibleProvider.notifier).setVisibility('');
                            }
                            },
                          icon: ref.watch(visibleProvider).value == '' ? Icon(Icons.visibility_off) : Icon(Icons.visibility))
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                      )),
                  Expanded(
                    flex: 4,
                    child: RadioListTile<int>(
                        title: Text('Donor'),
                        value: 0,
                        groupValue: ref.watch(radioProvider).value,
                        onChanged: (value){
                          ref.read(radioProvider.notifier).setValue(value!);
                        }
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: RadioListTile<int>(
                        title: Text('Receiver'),
                        value: 1,
                        groupValue: ref.watch(radioProvider).value,
                        onChanged: (value){
                          ref.read(radioProvider.notifier).setValue(value!);
                        }
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                      )),
                ],
              ),
              SizedBox(height: myHeight/100,),
              InkWell(
                onTap: ()async{
                  if(ref.watch(radioProvider).value == 0){
                    loginUser(emailController.text,passwordController.text,'Donor',ref,context);
                  }else{
                    loginUser(emailController.text,passwordController.text,'Receiver',ref,context);
                  }
                },
                child: Container(
                  height: myHeight/17,
                  width: myWidth/1.3,
                  decoration: BoxDecoration(
                    color: Color(CustomColors.PRIMARY_COLOR),
                    borderRadius: BorderRadius.all(Radius.circular(myWidth/20)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('Sign In',style: TextStyle(color: Colors.white,fontSize: (myWidth/1.3)/17,))),
                ),
              ),
              SizedBox(height: myHeight/50,),
              InkWell(
                onTap: ()async{
                  // UserCredential userCredential = await signInWithGoogle();
                  // if(ref.watch(radioProvider).value == 0){
                  //   signUpUser(userCredential.user!.photoURL!.toString(),userCredential.user!.displayName!,userCredential.user!.email!,'isSocial','Donor',context,ref,web3client!);
                  // }else{
                  //   signUpUser(userCredential.user!.photoURL!.toString(),userCredential.user!.displayName!,userCredential.user!.email!,'isSocial','Donor',context,ref,web3client!);
                  // }
                },
                child: Container(
                  height: myHeight/17,
                  width: myWidth/1.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(myWidth/20)),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('SignIn with Google',style: TextStyle(fontSize: (myWidth/1.3)/17,))),
                ),
              ),
              SizedBox(height: myHeight/60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have not account? '),
                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, Routers.SIGN_UP_PROFILE);
                      },
                      child: Text('Create Account',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR),fontSize: myWidth/25),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}