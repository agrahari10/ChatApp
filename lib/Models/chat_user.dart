import 'package:flutter/material.dart';

class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  late DateTime lastActive;

  ChatUser({
    required this.uid,
    required this.imageURL,
    required this.email,
    required this.lastActive,
    required this.name,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {
    return ChatUser(
        uid: _json["uid"],
        imageURL: _json["image"],
        email: _json["email"],
        lastActive: _json["last_active"].toDate(),
        // lastActive: DateTime.now(),
        name: _json["name"]);
  }
  Map<String ,dynamic> toMap(){
    return {
      "email":email,
      "Name" : name,
      "lastActive":lastActive,
      "Image" : imageURL,
      // "uid":uid
  };
}
String lastActiveday(){
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";

}
bool wasRecentlyActive(){
    return DateTime.now().difference(lastActive).inMinutes < 10;
  }

}