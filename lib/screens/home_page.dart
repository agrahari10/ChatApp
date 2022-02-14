import 'package:chat_system/screens/ChatScreen.dart';
import 'package:chat_system/screens/UsersPage.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    ChatsPage(),
    UsersPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return _buildUI(

    );
  }

  Widget _buildUI(){
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index){
          setState(() {
            _currentPage = _index;
          });

        },
        items: [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat_bubble_outline,
            ),
          ),
      BottomNavigationBarItem(
        label: "Users",
        icon: Icon(
          Icons.supervised_user_circle,
        ),
      ),
        ],
      ),
    );
  }
}