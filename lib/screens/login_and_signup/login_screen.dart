import 'package:betsquad/widgets/dual_coloured_text.dart';
import 'package:betsquad/screens/login_and_signup/signup_username_screen.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/styles/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String ID = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password = '';
  FirebaseServices _firebaseHelper = FirebaseServices();

  _signIn() async {
    await _firebaseHelper.signIn(_email, _password, onSuccess: () {
      Navigator.pushReplacementNamed(context, TabBarController.ID);
    }, bannedCallback: (duration) {
      Utility().showErrorAlertDialog(context, 'Account Suspended',
          'This account has been suspended until $duration');
    }, onError: (e){
      Utility().showErrorAlertDialog(context, 'Error', e.toString());
    });
  }

  _forgotPassword() async {
    _firebaseHelper.forgotPassword(_email, onSuccess: () {
      Utility().showErrorAlertDialog(context, 'Success',
          'A password reset link has been sent to your email');
    }, onError: (e) {
      Utility.getInstance()
          .showErrorAlertDialog(context, 'Error', e.toString());
    });
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
          _email = value;
        },
      ),
    );

    var passwordTextField = Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextField(
        obscureText: true,
        decoration: kPasswordTextFieldInputDecoration,
        onChanged: (value) {
          _password = value;
        },
      ),
    );

    var signInButton = Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 70,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
        color: kBetSquadOrange,
        onPressed: () async {
          if (_email != null && _password != null)
            _signIn();
          else
            Utility.getInstance().showErrorAlertDialog(context, "Invalid login",
                "Please enter a valid username and password");
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
              if (_email != null)
                _forgotPassword();
              else
                Utility.getInstance().showErrorAlertDialog(context,
                    "Invalid login", "Please enter a valid email address");
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, SignUpUsernameScreen.ID);
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
