import 'package:chat_system/Models/chat_user.dart';
import 'package:chat_system/Providers/authentication.dart';
import 'package:chat_system/Providers/user_page_provider.dart';
import 'package:chat_system/WWidgets/Custominput.dart';
import 'package:chat_system/WWidgets/Rounded.dart';
import 'package:chat_system/WWidgets/TopBar.dart';
import 'package:chat_system/WWidgets/custom_listtile.dart';
import 'package:chat_system/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late DatabaseServices _databaseServices;
  late User? _authh = FirebaseAuth.instance.currentUser;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;
  // late String Username;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  void initState() {
    _databaseServices = DatabaseServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _databaseServices = GetIt.instance.get<DatabaseServices>();
    // Username = _auth.user as String;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: _deviceHeight * 0.02,
            horizontal: _deviceWidth * 0.03,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              CustomTextField2(
                  controller: _searchFieldTextEditingController,
                  hintText: "Search...",
                  obscureText: false,
                  onEditingComplete: (_value) {
                    _pageProvider.getUsers(name: _value);
                    FocusScope.of(context).unfocus();
                  }),
              _userList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _userList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              // return Text("User $_index");
              // print(_authh);
              // print('');
              print(_users[_index].email);
              print('SSS'*100);
              if (_authh?.email != _users[_index].email){
                return CustomListViewTile(
                    height: _deviceHeight * 0.10,
                    imagePath: _users[_index].imageURL,
                    title: _users[_index].name,
                    isActive: _users[_index].wasRecentlyActive(),
                    isSelected:
                    _pageProvider.selectedUsers.contains(_users[_index]),
                    onTap: () {
                      _pageProvider.updateSelectedUsers(_users[_index]);
                    },
                    subtitle: "Last Active ${_users[_index].lastActiveday()}");
              }
              return SizedBox();

            },
          );
        } else {
          return Center(
            child: Text(
              "No users found",
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
    }());
  }

  Widget _createChatButton() {
    // ChatUser thisCurrentUser = _databaseServices.getCurrentUser();
    // final thisIsCurrentUser = FirebaseAuth.instance.currentUser;
    // print(_pageProvider.selectedUsers.contains(thisCurrentUser) );
    // print("#"*200);
    // return
    // DatabaseService.;
    // _pageProvider.selectedUsers.contains(thisCurrentUser) ?
    // SizedBox():
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
          width: _deviceWidth * 0.80,
          height: _deviceHeight * 0.08,
          // ignore: unrelated_type_equality_checks
          name: _pageProvider.selectedUsers.length == 1
              ? "Chat With ${_pageProvider.selectedUsers.first.name}"
              : "Create Group Chat",
          onPressed: () {
            _pageProvider.createChat();
          }),
    );
  }
}
