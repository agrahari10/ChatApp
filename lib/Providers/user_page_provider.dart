import 'package:chat_system/Models/chat.dart';
import 'package:chat_system/Models/chat_user.dart';
import 'package:chat_system/Providers/authentication.dart';
import 'package:chat_system/screens/ChatPage.dart';
import 'package:chat_system/services/database.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DatabaseServices _database;
  late NavigationServices _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseServices>();
    _navigation = GetIt.instance.get<NavigationServices>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    // String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      _database.getUsers(name: name).then((_snapshot) {
        // var currentUser;
        users = _snapshot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data["uid"] = _doc.id;
          // if (currentUserId == _data["uid"]) currentUser = _data[currentUserId];
          return ChatUser.fromJSON(_data);
        }).toList();
        // users!.remove(currentUserId);
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    // Create Chat....
    try {
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user.uid);
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? doc = await _database.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _membersIds,
      });
      List<ChatUser> _members = [];
      for (var _uid in _membersIds) {
        DocumentSnapshot _userSnapShot = await _database.getUser(_uid);
        // ignore: unnecessary_statements
        Map<String, dynamic> _userData =
            _userSnapShot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapShot.id;
        _members.add(ChatUser.fromJSON(_userData));
      }
      ChatPage _chatPage = ChatPage(
        chat: Chat(
            uid: doc!.id,
            activity: false,
            members: _members,
            currentUserid: _auth.user.uid,
            group: _isGroup,
            message: []),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(_chatPage);
    } catch (e) {
      print(e);
    }
  }
}
