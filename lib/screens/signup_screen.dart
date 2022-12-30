import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../Pages.dart';
import '../colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../logic/signup_data.dart';
import '../states/RadioState.dart';
import '../states/Visible_Password.dart';
import '../states/imageState.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {

  final fileProvider = StateNotifierProvider<imageProvider,ImageState>((ref)=> imageProvider(file: 0));
  final visiblilityProvider = StateNotifierProvider<VisibleProvider,VisibleState>((ref) => VisibleProvider(value: ''));
  final radioProvider = StateNotifierProvider<RadioProvider,RadioState>((ref) => RadioProvider(value: 0));

  List<String> menuItems = ['Select Group','A+','A-','B+','B-','O+','O-','AB+','AB-'];
  String itemValue = 'Select Group';

  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode focusController = FocusNode();

  File? imageFile;
  String? filePath;
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


  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: myHeight/25,),
                // Container(
                //   height: myHeight/4,
                //   width: myWidth,
                //   child: Image.asset('assets/signin_blood.png'),
                // ),
                Text('Welcome',style: TextStyle(fontSize: myWidth/15),),
                SizedBox(height: myHeight/30,),
                InkWell(
                  onTap: (){
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: myHeight / 3,
                            child: Column(
                              children: [
                                SizedBox(height: (myHeight/3)/5,),
                                Container(
                                  height: (myHeight/3) / 5,
                                  width: myWidth/1.5,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      getCameraImage();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.camera,color: Colors.white,),
                                        Spacer(),
                                        Text('From Camera',style: TextStyle(color: Colors.white,fontSize: myWidth/20),),
                                        Spacer(),
                                        Spacer(),
                                        Spacer(),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(CustomColors.PRIMARY_COLOR)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(7)),
                                      ),
                                      )
                                    )
                                  ),
                                ),
                                SizedBox(height: (myHeight/3)/10,),
                          Container(
                          height: (myHeight/3) / 5,
                          width: myWidth/1.5,
                          child: ElevatedButton(
                          onPressed: (){
                            getGalleryImage();
                          },
                          child: Row(
                          children: [
                          Icon(Icons.photo,color: Colors.white,),
                          Spacer(),
                          Text('From Gallery',style: TextStyle(color: Colors.white,fontSize: myWidth/20),),
                          Spacer(),
                          Spacer(),
                            Spacer(),
                          ],
                          ),
                          style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(CustomColors.PRIMARY_COLOR)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          )
                          )
                          )
                          )
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: CircleAvatar(
                        child: ref.watch(fileProvider).fileValue == 0 ? Image.asset('assets/man.png',height: myHeight / 10,width: myWidth / 10,)
                          : CircleAvatar(
                            backgroundImage: FileImage(imageFile!),
                            radius: myHeight / 20,
                          ),
                          radius: myWidth / 10,backgroundColor: Colors.grey),
                    ),
                  ),
                ),
                Text('Tap to change',style: TextStyle(fontSize: myWidth/35,color: Colors.grey),),
                SizedBox(height: myHeight/30,),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        helperText: '',
                      labelText: 'UserName',
                      hintText: 'Enter UserName',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                      ),
                      prefixIcon: Icon(Icons.drive_file_rename_outline_rounded)
                    ),
                  ),
                ),
                SizedBox(height: myHeight/100,),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child:TextField(
                    focusNode: focusController,
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        helperText: ref.watch(existProvider).value == '' ? '' : ref.watch(existProvider).value,
                        helperStyle: TextStyle(
                          color: ref.watch(existProvider).value == '' ? Colors.grey : Colors.red,
                        ),
                        hintText: 'Enter Email',
                        focusedBorder: ref.watch(existProvider).value == '' ? OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue,width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                        ) : OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(myWidth/30)),
                        ),
                        prefixIcon: Icon(Icons.email)
                    ),
                  )
                ),
                SizedBox(height: myHeight/100,),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: ref.watch(visiblilityProvider).value == '' ? true : false,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        helperText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                        ),
                        prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                          onPressed: (){
                            if(ref.watch(visiblilityProvider).value == ''){
                              ref.read(visiblilityProvider.notifier).setVisibility('visible');
                            }else{
                              ref.read(visiblilityProvider.notifier).setVisibility('');
                            }
                          },
                          icon: ref.watch(visiblilityProvider).value == '' ? Icon(Icons.visibility_off) : Icon(Icons.visibility))
                    ),
                  ),
                ),
                SizedBox(height: myHeight/100,),
                Padding(
                  padding: EdgeInsets.only(left: myWidth/10,right: myWidth/10),
                  child: TextField(
                    controller: numberController,
                    decoration: InputDecoration(
                        labelText: 'Number',
                        hintText: '11 digit Number 03xxxxxxxxx',
                        helperText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(myWidth/30))
                        ),
                        prefixIcon: Icon(Icons.call),
                    ),
                  ),
                ),
                SizedBox(height: myHeight/100,),
                Container(
                  height: myHeight / 20,
                  width: myWidth / 1.2,
                  margin: EdgeInsets.symmetric(horizontal: myWidth/10),
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
                SizedBox(height: myHeight/100,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: myWidth/30),
                          child: Center(child: Text('Category',style: TextStyle(fontSize: myWidth/25,fontWeight: FontWeight.w700),)),
                        )),
                    Expanded(
                      flex: 2,
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
                      flex: 2,
                      child: RadioListTile<int>(
                          title: Text('Receiver'),
                          value: 1,
                          groupValue: ref.watch(radioProvider).value,
                          onChanged: (value){
                            ref.read(radioProvider.notifier).setValue(value!);
                          }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: myHeight/40,),
                InkWell(
                  onTap: ()async{
                    if(nameController == ''){
                      Fluttertoast.showToast(
                          msg: "Please give UserName",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else if(emailController.text == ''){
                      Fluttertoast.showToast(
                          msg: "Please give Email",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else if(passwordController.text == ''){
                      Fluttertoast.showToast(
                          msg: "Please give Password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else if(filePath == ''){
                      Fluttertoast.showToast(
                          msg: "Please give file",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    else{
                      if(ref.read(existProvider).value == ''){
                        print('');
                      }else{
                        focusController.requestFocus();
                      }
                      if(ref.watch(radioProvider).value == 0){
                        signUpUser(imageFile!,nameController.text,emailController.text,passwordController.text,'Donor',numberController.text,itemValue,context,ref,web3client!);
                      }else{
                        signUpUser(imageFile!,nameController.text,emailController.text,passwordController.text,'Receiver',numberController.text,itemValue,context,ref,web3client!);
                      }
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
                    child: Center(child: Text('Create Account',style: TextStyle(color: Colors.white,fontSize: (myWidth/1.3)/17,))),
                  ),
                ),
                SizedBox(height: myHeight/40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? '),
                    InkWell(
                        onTap: ()async{
                          Navigator.pushNamed(context, Routers.SIGN_IN_SCREEN);
                        },
                        child: Text('Sign In',style: TextStyle(color: Color(CustomColors.PRIMARY_COLOR),fontSize: myWidth/23),)),
                  ],
                )
              ],
            ),
          )
        ),
      ),
    );
  }


  void getCameraImage()async{

    final cameraImage = ImagePicker();
    XFile? file = await cameraImage.pickImage(source: ImageSource.camera);
    File cameraFile = File(file!.path);
    imageFile = cameraFile;
    filePath = file.path;
    if(filePath != ''){
      Navigator.pop(context);
    }

    ref.read(fileProvider.notifier).setFile(1);

  }

  void getGalleryImage()async{

    final cameraImage = ImagePicker();
    XFile? file = await cameraImage.pickImage(source: ImageSource.gallery);
    File galleryFile = File(file!.path);
    imageFile = galleryFile;
    filePath = file.path;
    if(filePath != ''){
      Navigator.pop(context);
    }

    ref.read(fileProvider.notifier).setFile(1);
    
  }

  DropdownMenuItem<String> dropDownItem(String item){
    return DropdownMenuItem(
        value: item,
        child: Text(item)
    );
  }

}
