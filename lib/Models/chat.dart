import 'package:chat_system/Models/Chat_message.dart';
import 'package:chat_system/Models/chat_user.dart';
import 'package:flutter/material.dart';

class Chat {
  final String uid;
  final String currentUserid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> message;
  late final List<ChatUser> _recepients;

  Chat({
    required this.uid,
    required this.activity,
    required this.members,
    required this.currentUserid,
    required this.group,
    required this.message,
  }) {
    _recepients = members.where((_i) => _i.uid != currentUserid).toList();
  }
  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients.map((_user) => _user.name).join(",");
  }

  String imageUrl() {
    return !group
        ? _recepients.first.imageURL
        : "https://htmlcolorcodes.com/assets/images/colors/red-color-solid-background-1920x1080.png";
  }
}
