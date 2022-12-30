import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future uploadSnapShot(String id,File file,BuildContext context,TextEditingController controller)async{

  var stream = new http.ByteStream(file.openRead());
  stream.cast();
  // get file length
  var length = await file.length();
  
  var request = http.MultipartRequest('POST',Uri.parse('http://192.168.100.36:5000/api/screenshot'));
  request.fields['id'] = id;

  var multipartFile = http.MultipartFile('imageShot',stream,length,filename: file.path);

  request.files.add(multipartFile);

  var response = await request.send();

  if(response.statusCode == 200){
      Navigator.pop(context,{'address': controller.text});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('uploaded successfully')));
  }else{
    print('error is ${response.statusCode}');
  }

}
