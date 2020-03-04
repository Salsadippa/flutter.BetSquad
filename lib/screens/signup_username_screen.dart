import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/custom_widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/custom_widgets/full_width_button.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_description.dart';
import 'package:betsquad/screens/signup_userinfo_screen.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class SignUpUsernameScreen extends StatefulWidget {
  static const String id = 'signup_username_screen';

  @override
  _SignUpUsernameScreenState createState() => _SignUpUsernameScreenState();
}

class _SignUpUsernameScreenState extends State<SignUpUsernameScreen> {
  String username;
  var appBar = BetSquadLogoAppBar();
  Map<String,Object> userDetails = {};

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

    var photo = CircleAvatar(
      backgroundColor: Colors.orange,
      radius: 70,
      child: CircleAvatar(
        backgroundImage: kUserPlaceholderImage,
        radius: 67,
      ),
    );

    var usernameTextField = TextFieldWithTitleDesc(
        title: 'Username',
        onChangeTextField: (String value) {
          username = value.trim();
        });

    return Scaffold(
      appBar: appBar,
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
              if (username.isNotEmpty) {
                var available = await UsersApi().usernameIsAvailable(username);
                if (available) {
                  userDetails["username"] = username;
                  Navigator.pushNamed(context, SignupUserInfoScreen.id, arguments: userDetails);
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
