import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';

class MediaServices{

  MediaServices(){}

  Future<PlatformFile?> pickImageFromLibrary()async{
    FilePickerResult? _result = await FilePicker.platform.pickFiles(type: FileType.image,allowCompression: true);

    if (_result != null){
      return _result.files[0];
    }
    else
      return null;
  }
}