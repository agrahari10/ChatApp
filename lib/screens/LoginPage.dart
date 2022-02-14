import 'package:chat_system/Providers/authentication.dart';
import 'package:chat_system/WWidgets/Custominput.dart';
import 'package:chat_system/WWidgets/Rounded.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late NavigationServices _navigationService;

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationServices>();
    return _buildUI();
  }

  Widget _loginButton() {
    return RoundedButton(
        width: _deviceWidth * 0.65,
        height: _deviceHeight * 0.065,
        name: 'Login',
        onPressed: () {
          if(_loginFormKey.currentState!.validate()){
            _loginFormKey.currentState!.save();
            // print("Email: $_email,Password: $_password");
            _auth.loginUsingEmailAndPassword(_email!, _password!);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registering')),
            );
          }
        });
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceHeight * 0.03,
          vertical: _deviceWidth * 0.03,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            _loginButton(),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            _AccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHeight * 0.10,
      // width: _deviceWidth*0.9,
      child: Text(
        'Chatify',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _AccountLink(){
    return GestureDetector(
      onTap: (){
        _navigationService.navigateToRoute('/register');
      },
      child: Container(
        child: Text("Don'\ t have an account?",style:TextStyle(
          color: Colors.blueAccent,
        ) ,),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHeight * 0.20,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              obscureText: false,
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              hintText: "Email",
              regEx: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            ),
            CustomTextField(
              obscureText: false,
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              hintText: "Password",
              regEx: r'.{8,}',
            )
          ],
        ),
      ),
    );
  }
}
