import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:chat_system/Models/Chat_message.dart';
import 'package:chat_system/Providers/authentication.dart';
import 'package:chat_system/services/cloud_storage.dart';
import 'package:chat_system/services/database.dart';
import 'package:chat_system/services/media_serviceas.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseServices _db;
  late CloudStorageServices _storage;
  late MediaServices _media;
  late NavigationServices _navigation;

  AuthenticationProvider _auth;
  ScrollController _messagesListViewController;
  String _chatId;
  List<ChatMessage>? messages;
  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisbilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;
  String? _message;
  String get message {
    return message;
  }

  void set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseServices>();
    _storage = GetIt.instance.get<CloudStorageServices>();
    _media = GetIt.instance.get<MediaServices>();
    _navigation = GetIt.instance.get<NavigationServices>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToKeyboardChanges();
    listenToMessage();
  }
  @override
  void dispose() {
    // _messagesStream.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void listenToMessage() {
    try {
      _messagesStream = _db.streamMessageForChat(_chatId).listen((_snapshot) {
        List<ChatMessage> _message = _snapshot.docs.map(
          (_m){
            Map<String, dynamic> _messageData =
                _m.data() as Map<String, dynamic>;
            return ChatMessage.fromJSON(_messageData);
          },
        ).toList();
        messages = _message;
        notifyListeners();
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if(_messagesListViewController.hasClients){
            _messagesListViewController
            .jumpTo(_messagesListViewController.position.maxScrollExtent);
          }
          
        });
        
      });
    } catch (e) {
      print('Error getting Messages');
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisbilityStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatId, {"is_activity": _event});
    });
  }

  void sendTextMessage() {
    print(_message);
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );
      // print(_messageToSend);
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _dowanloadURL = await _storage.saveChatImageToStorage(
            _chatId, _auth.user.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
          content: _dowanloadURL!,
          type: MessageType.IMAGE,
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
