import 'package:betsquad/custom_widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/custom_widgets/checkbox_with_description.dart';
import 'package:betsquad/custom_widgets/full_width_button.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_description.dart';
import 'package:betsquad/screens/signup_address_screen.dart';
import 'package:flutter/material.dart';

class SignupUserInfoScreen extends StatefulWidget {
  static String id = 'signup_userinfo_screen';

  @override
  _SignupUserInfoScreenState createState() => _SignupUserInfoScreenState();
}

class _SignupUserInfoScreenState extends State<SignupUserInfoScreen> {
  String dob, firstName, lastName, email, password, confirmPassword;
  bool termsAndConditionsOptIn, marketingOptIn = false;

  @override
  Widget build(BuildContext context) {
    var dobTextField = TextFieldWithTitleDesc(
        title: 'D.O.B',
        detail:
            'BetSquad is a social betting app. You must be over 18 to play.',
        onChangeTextField: (value) {
          dob = value;
        });
    var firstNameTextField = TextFieldWithTitleDesc(
        title: 'First Name',
        onChangeTextField: (value) {
          firstName = value;
        });
    var lastNameTextField = TextFieldWithTitleDesc(
        title: 'Last Name',
        onChangeTextField: (value) {
          lastName = value;
        });
    var emailTextField = TextFieldWithTitleDesc(
        title: 'Email',
        onChangeTextField: (value) {
          email = value;
        });
    var passwordTextField = TextFieldWithTitleDesc(
        title: 'Password',
        shouldObscureText: true,
        onChangeTextField: (value) {
          password = value;
        });
    var confirmPasswordTextField = TextFieldWithTitleDesc(
        title: 'Confirm Password',
        shouldObscureText: true,
        onChangeTextField: (value) {
          confirmPassword = value;
        });

    var termsAndConditionsCheckbox = CheckboxWithDescription(
        'By creating an account you are agreeing to BetSquad\'s Terms and Conditions',
        termsAndConditionsOptIn, (value) {
      setState(() {
        termsAndConditionsOptIn = value;
      });
    });

    var marketingCheckbox = CheckboxWithDescription(
        'I would like to receive the latest news, updates and offers from BetSquad via email',
        marketingOptIn, (value) {
      setState(() {
        marketingOptIn = value;
        if (marketingOptIn){
          print("opted in");
        } else {
          print("opted out");
        }
      });
    });

    var nextButton = FullWidthButton('Next', () {
      Navigator.pushNamed(context, SignupAddressScreen.id);
    });

    return Scaffold(
//      backgroundColor: Colors.black,
      appBar: BetSquadLogoAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            dobTextField,
            firstNameTextField,
            lastNameTextField,
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            termsAndConditionsCheckbox,
            marketingCheckbox,
            nextButton,
          ],
        ),
      ),
    );
  }
}
