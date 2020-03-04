import 'package:betsquad/custom_widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/custom_widgets/checkbox_with_description.dart';
import 'package:betsquad/custom_widgets/full_width_button.dart';
import 'package:betsquad/custom_widgets/text_field_with_date_picker.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_description.dart';
import 'package:betsquad/screens/signup_address_screen.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignupUserInfoScreen extends StatefulWidget {
  static const String id = 'signup_userinfo_screen';

  @override
  _SignupUserInfoScreenState createState() => _SignupUserInfoScreenState();
}

class _SignupUserInfoScreenState extends State<SignupUserInfoScreen> {
  DateTime dob;
  String firstName = '', lastName = '', email = '', password = '', confirmPassword = '';
  bool termsAndConditionsOptIn = false;
  bool marketingOptIn = false;
  var formatter = new DateFormat('dd-MM-yyyy');

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String,Object> userDetails = ModalRoute.of(context).settings.arguments;

    var dobTextField = TextFieldWithDatePicker(
      title: 'D.O.B',
      value: dob != null ? formatter.format(dob) : '',
      onDateChanged: (value) {
        int age = _calculateAge(value);
        if (age >= 18) {
          setState(() {
            dob = value;
          });
        } else {
          Utility().showErrorAlertDialog(context, 'You must be over 18',
              'BetSquad is a social betting app. You must be over 18 to play.');
        }
      },
      detail: 'BetSquad is a social betting app. You must be over 18 to play.',
    );

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
      });
    });

    var nextButton = FullWidthButton('Next', () {
      if (dob != null &&
          firstName.trim().isNotEmpty &&
          lastName.trim().isNotEmpty &&
          email.trim().isNotEmpty &&
          password.trim().isNotEmpty &&
          confirmPassword.trim().isNotEmpty) {
        if (password != confirmPassword) {
          Utility().showErrorAlertDialog(context, 'Passwords do not match',
              'The passwords entered do not match');
          return;
        }
        if (!termsAndConditionsOptIn) {
          Utility().showErrorAlertDialog(context, 'Terms and Conditions',
              'You must accept the terms and conditions to continue');
          return;
        }

        userDetails["dob"] = formatter.format(dob);
        userDetails["firstName"] = firstName;
        userDetails["lastName"] = lastName;
        userDetails["email"] = email;
        userDetails["password"] = password;
        userDetails["marketingOptIn"] = marketingOptIn;

        Navigator.pushNamed(context, SignupAddressScreen.id, arguments: userDetails);
        return;
      } else {
        Utility().showErrorAlertDialog(context, 'Missing fields',
            'Please fill in all fields and try again');
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey,
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
