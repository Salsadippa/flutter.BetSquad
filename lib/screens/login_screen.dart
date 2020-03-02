import 'package:betsquad/custom_widgets/dual_coloured_text.dart';
import 'package:betsquad/screens/signup_username_screen.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password = '';
  FirebaseServices firebaseHelper = FirebaseServices();

  signIn() async {
    try {
      final user = await firebaseHelper.signIn(email, password);
      if (user != null) {
        print("signed in");
      }
    } catch (e) {
      print(e);
      Utility.getInstance().showErrorAlertDialog(context, 'Error', e.toString());
    }
  }

  forgotPassword() async {
    try {
      final _ = await firebaseHelper.forgotPassword(email);
      print("email sent");

    } catch(e){
      Utility.getInstance().showErrorAlertDialog(context, 'Error', e.toString());

    }
  }

  @override
  Widget build(BuildContext context) {
    var betSquadLogo = Container(
        height: 110,
        child: Image(
          image: kBetSquadLogoImage,
        ));

    var spacing = SizedBox(
      height: 30,
    );

    var pleaseLoginText = DualColouredText('v1.0.', 'Please log in');

    var emailTextField = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: TextField(
        decoration: kEmailTextFieldInputDecoration,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          email = value;
        },
      ),
    );

    var passwordTextField = Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextField(
        obscureText: true,
        decoration: kPasswordTextFieldInputDecoration,
        onChanged: (value) {
          password = value;
        },
      ),
    );

    var signInButton = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 70,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
        color: Colors.orange,
        onPressed: () async {
          if (email != null && password != null)
            signIn();
          else
            Utility.getInstance().showErrorAlertDialog(context, "Invalid login", "Please enter a valid username and password");
        },
        child: const Text('Sign In',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );

    var forgotPasswordAndSignupButtons = Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              print("forgot password");
              if (email != null)
                forgotPassword();
              else
                Utility.getInstance().showErrorAlertDialog(context, "Invalid login", "Please enter a valid email address");
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, SignUpUsernameScreen.id);
            },
            child: Text(
              'New here? Sign up',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: Container(
        decoration: kPitchBackgroundDecoration,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              betSquadLogo,
              spacing,
              pleaseLoginText,
              emailTextField,
              passwordTextField,
              signInButton,
              forgotPasswordAndSignupButtons
            ],
          ),
        ),
      ),
    );
  }
}
