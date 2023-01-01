import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future uploadSnapShot(String id,File file,BuildContext context)async{

  var stream = new http.ByteStream(file.openRead());
  stream.cast();
  // get file length
  var length = await file.length();
  
  var request = http.MultipartRequest('POST',Uri.parse('http://192.168.100.36:5000/api/screenshot'));
  request.fields['id'] = id;
  request.fields['date'] = getCurrentDate();

  var multipartFile = http.MultipartFile('imageShot',stream,length,filename: file.path);

  request.files.add(multipartFile);

  var response = await request.send();

  if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('uploaded successfully')));
  }else{
    print('error is ${response.statusCode}');
  }

}

Future getUserSnapShot(String userId,BuildContext context)async{
  var response = await http.get(Uri.parse('http://192.168.100.36:5000/api/fetch/screenshot/${userId}'));

  if(response.statusCode == 200){
    return response.body;
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error is ${response.statusCode}')));
  }

}


String getCurrentDate() {
  var date = DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
  return formattedDate.toString();
}