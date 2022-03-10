import 'dart:ffi';

import 'package:chat_system/Models/Chat_message.dart';
import 'package:chat_system/Models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "messages";

class DatabaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance.currentUser;
  late ChatUser thisUser;
  // DatabaseServices() {
  //   currentUser(_auth!.uid).then((value) {
  //     thisUser = value;
  //   });
  // }

  // ChatUser get getCurrentUser => thisUser;
  ChatUser getCurrentUser() {
    return thisUser;
  }

  Future<void> createUser(
    String _uid,
    String _email,
    String _name,
    String _imageUrl,
  ) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set({
        "email": _email,
        "name": _name,
        "last_active": DateTime.now().toUtc(),
        "image": _imageUrl,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
     print(_auth!.email);
      print("7"*100);
     // DocumentSnapshot document = _db.collection(USER_COLLECTION).doc(_uid).get();
     // if {

     // }
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  // Future<DocumentSnapshot> currentUser(String? _uid) async{
  //   Query _queryy = _db.collection(USER_COLLECTION).where(_uid!);
  //   print(_queryy.get());
  //   print("Abcd"*100);
  //   var doc =await _queryy.get();
  //   var data = doc.docs[0].data()!;
  //   print(data);
  // Map<String, dynamic> _userData =
  //                   _queryy.data as Map<String, dynamic>;
  //                   _userData["uid"] = doc.;
  //               _members.add(
  //                 ChatUser.fromJSON(_userData),
  //               );

  //   // return ChatUser(uid: uid, imageURL: data., email: email, lastActive: lastActive, name: name)
  // }
  Future<QuerySnapshot> getUsers({String? name}) {
    print(_auth!.email);
    print('900'*100);
    Query _query = _db.collection(USER_COLLECTION).where("name",isNotEqualTo: _auth!.email);
     print(_auth!.email);
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    // print('object'*100);
    // print(_db
    //     .collection(CHAT_COLLECTION)
    //     .where('members', arrayContains: _uid)
    //     .snapshots());
    return _db
        .collection(CHAT_COLLECTION)
        .where(
          'members',
          // isNotEqualTo: _auth!.email,
          arrayContains: _uid,
        )
        .snapshots();

  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessage _message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatID)
          .collection(MESSAGE_COLLECTION)
          .add(_message.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserlastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat =
          await _db.collection(CHAT_COLLECTION).add(_data);
      return _chat;
    } catch (e) {
      print(e);
    }
  }
}
