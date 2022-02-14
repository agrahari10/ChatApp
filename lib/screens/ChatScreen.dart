import 'package:chat_system/Models/Chat_message.dart';
import 'package:chat_system/Models/chat.dart';
import 'package:chat_system/Models/chat_user.dart';
import 'package:chat_system/Providers/authentication.dart';
import 'package:chat_system/Providers/chatPageProvider.dart';
import 'package:chat_system/WWidgets/TopBar.dart';
import 'package:chat_system/WWidgets/custom_listtile.dart';
import 'package:chat_system/screens/ChatPage.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late ChatPageProvider _PageProvider;
  late NavigationServices _navigation;

  @override
  Widget build(BuildContext context){
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationServices>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _PageProvider = _context.watch<ChatPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceHeight * 0.03,
          vertical: _deviceWidth * 0.02,
        ),
        height: _deviceHeight * 0.9,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Chats',
              primaryAction: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ),
            _chatList()
          ],
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? _chats = _PageProvider.chats;
    print(_chats);
    return SizedBox(
      height: _deviceHeight * 0.6,
      child: (() {
      if (_chats != null) {
        if (_chats.length != 0) {
          return ListView.builder(
            itemCount: _chats.length,
            itemBuilder: (BuildContext _context, int _index) {
              return _chatTile(
                _chats[_index],
              );
            },
          );
        } else {
          return Center(
            child: Text(
              'No Chats found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    })());
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subtitleText = "";
    if (_chat.message.isNotEmpty) {
      // print(MessageType.IMAGE);
      _subtitleText = _chat.message.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.message.first.content;
    }
    return CustomListViewTileWithActivity(
        height: _deviceHeight * 0.10,
        imagePath:_chat.imageUrl(),
        title: _chat.title(),
        isActive: _isActive,
        isActivity: _chat.activity,
        onTap: () {
          _navigation.navigateToPage(ChatPage(chat: _chat),
          );
        },
        subtitle: _subtitleText
        );
  }
}
