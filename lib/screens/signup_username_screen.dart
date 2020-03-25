import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/text_field_with_title_description.dart';
import 'package:betsquad/screens/signup_userinfo_screen.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:image_picker/image_picker.dart';

class SignUpUsernameScreen extends StatefulWidget {
  static const String ID = 'signup_username_screen';

  @override
  _SignUpUsernameScreenState createState() => _SignUpUsernameScreenState();
}

class _SignUpUsernameScreenState extends State<SignUpUsernameScreen> {
  String _username;
  var _appBar = BetSquadLogoAppBar();
  Map<String,Object> _userDetails = {};
  var _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    var uploadPhotoText = Container(
      padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Text(
        'Upload a photo - this is what everyone will see so make it good!',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );

    var spacing = SizedBox(
      height: 30,
    );

    var photo = GestureDetector(
      onTap: () => getImage(),
      child:  CircleAvatar(
        backgroundColor: Colors.orange,
        radius: 70,
        child: CircleAvatar(
          backgroundImage: _image != null ? FileImage(_image) : kUserPlaceholderImage,
          radius: 67,
        ),
      ),
    );

    var usernameTextField = TextFieldWithTitleDesc(
        title: 'Username',
        onChangeTextField: (String value) {
          _username = value.trim();
        });

    return Scaffold(
      appBar: _appBar,
      body: Container(
        color: Colors.black87,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            uploadPhotoText,
            spacing,
            photo,
            spacing,
            usernameTextField,
            FullWidthButton('Next', () async {
              if (_username.isNotEmpty) {
                var available = await UsersApi.usernameIsAvailable(_username);
                if (available) {
                  _userDetails["username"] = _username;
                  _userDetails["image"] = _image;
                  Navigator.pushNamed(context, SignupUserInfoScreen.ID, arguments: _userDetails);
                }
                else {
                  Utility().showErrorAlertDialog(context, 'Username taken',
                      'This username is already in use please enter a different username');
                }
              } else {
                Utility().showErrorAlertDialog(context, 'Missing username',
                    'Please enter a username to continue');
              }

            })
          ],
        ),
      ),
    );
  }
}
