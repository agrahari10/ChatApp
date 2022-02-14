// import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";
class CloudStorageServices{
  
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudStorageServices(){}

  Future<String?> saveUserImageToStorage(String _uid,PlatformFile _file)async{
    // File file = File(filePath);
    try{
      Reference _ref = _storage.ref().child('images/users/$_uid/profile.${_file.extension}');
      

      // ignore: unused_local_variable
      UploadTask _task = _ref.putFile(File(_file.path.toString()),);
      return await _task.then((_result) => _result.ref.getDownloadURL());
    }
    catch(e){
      print(e);
    }

  }

  Future<String?> saveChatImageToStorage(String _chatID,String _userID,PlatformFile _file)async{
    // File file = File(filePath);
    try{
      Reference _ref = _storage.ref().child('images/chats/$_chatID/$_userID/${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}');
      

      // ignore: unused_local_variable
      UploadTask _task = _ref.putFile(File(_file.path.toString()),);
      return await _task.then((_result) => _result.ref.getDownloadURL());
    }
    catch(e){
      print(e);
    }

  }

}
