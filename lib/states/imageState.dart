import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageState{

  int fileValue;
  ImageState({required this.fileValue});

  ImageState copyWith(int newFile){
    return ImageState(fileValue: newFile);
  }

}

class imageProvider extends StateNotifier<ImageState>{
  imageProvider({required int file}) : super(ImageState(fileValue: file));

  void setFile(int file) => state = state.copyWith(file);

}