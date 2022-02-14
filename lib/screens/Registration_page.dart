import 'package:chat_system/Providers/authentication.dart';
import 'package:chat_system/WWidgets/Custominput.dart';
import 'package:chat_system/WWidgets/Rounded.dart';
import 'package:chat_system/WWidgets/Rounded_image.dart';
import 'package:chat_system/services/cloud_storage.dart';
import 'package:chat_system/services/database.dart';
import 'package:chat_system/services/media_serviceas.dart';
import 'package:chat_system/services/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseServices _db;
  late CloudStorageServices _cloudStorageServices;
  late NavigationServices _navigation;

  PlatformFile? _profileImage;
  String? _email;
  String? _password;
  String? _name;

  final _registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context); // for registration
    _db = GetIt.instance.get<DatabaseServices>(); // databases
    _cloudStorageServices =
        GetIt.instance.get<CloudStorageServices>(); // cloudStorgae in firebase
    _navigation  = GetIt.instance.get<NavigationServices>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.003),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _profileImageField(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _registerForm(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(onTap: () {
      GetIt.instance.get<MediaServices>().pickImageFromLibrary().then((_file) {
        setState(() {
          _profileImage = _file;
        });
      });
    }, child: () {
      if (_profileImage != null) {
        return RoundedImageFile(
            key: UniqueKey(),
            size: _deviceHeight * 0.15,
            image: _profileImage!);
      } else {
        return RoundedImage(
          key: UniqueKey(),
          imagePath:
              'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/emma-stone-and-dave-mccary-attend-the-golden-state-warriors-news-photo-1084887700-1548534373.jpg?crop=1.00xw:0.675xh;0,0.0137xh&resize=980:*',
          size: _deviceHeight * 0.015,
        );
      }
    }());
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.25,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              obscureText: false,
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              hintText: "Name",
              regEx: r'.{8,}',
            ),
            CustomTextField(
              obscureText: false,
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              hintText: "Email",
              regEx: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',

              // regEx: r'.{8,}',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
        width: _deviceWidth * 0.65,
        height: _deviceHeight * 0.065,
        name: 'Register',
        onPressed: ()async {
          if(_registerFormKey.currentState!.validate() && _profileImage != null){
            _registerFormKey.currentState!.save();
            String? _uid = await _auth.registerUserUsingEmailAndPassword(_email!, _password!);

            String? _imageUrl = await _cloudStorageServices.saveUserImageToStorage(_uid!, _profileImage!);
            await _db.createUser(_uid, _email!, _name!, _imageUrl!);
            CircularProgressIndicator();
            await _auth.logout();
            await _auth.loginUsingEmailAndPassword(_email!, _password!);
          }
        });
  }
}
