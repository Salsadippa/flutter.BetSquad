import 'package:betsquad/widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/widgets/checkbox_with_description.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/text_field_with_date_picker.dart';
import 'package:betsquad/widgets/text_field_with_title_description.dart';
import 'package:betsquad/screens/login_and_signup/signup_address_screen.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignupUserInfoScreen extends StatefulWidget {
  static const String ID = 'signup_userinfo_screen';

  @override
  _SignupUserInfoScreenState createState() => _SignupUserInfoScreenState();
}

class _SignupUserInfoScreenState extends State<SignupUserInfoScreen> {
  DateTime _dob;
  String _firstName = '', _lastName = '', _email = '', _password = '', _confirmPassword = '';
  bool _termsAndConditionsOptIn = false;
  bool _marketingOptIn = false;
  var _formatter = new DateFormat('dd-MM-yyyy');

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
      value: _dob != null ? _formatter.format(_dob) : '',
      onDateChanged: (value) {
        int age = _calculateAge(value);
        if (age >= 18) {
          setState(() {
            _dob = value;
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
          _firstName = value;
        });
    var lastNameTextField = TextFieldWithTitleDesc(
        title: 'Last Name',
        onChangeTextField: (value) {
          _lastName = value;
        });
    var emailTextField = TextFieldWithTitleDesc(
        title: 'Email',
        onChangeTextField: (value) {
          _email = value;
        });
    var passwordTextField = TextFieldWithTitleDesc(
        title: 'Password',
        shouldObscureText: true,
        onChangeTextField: (value) {
          _password = value;
        });
    var confirmPasswordTextField = TextFieldWithTitleDesc(
        title: 'Confirm Password',
        shouldObscureText: true,
        onChangeTextField: (value) {
          _confirmPassword = value;
        });

    var termsAndConditionsCheckbox = CheckboxWithDescription(
        'By creating an account you are agreeing to BetSquad\'s Terms and Conditions',
        _termsAndConditionsOptIn, (value) {
      setState(() {
        _termsAndConditionsOptIn = value;
      });
    });

    var marketingCheckbox = CheckboxWithDescription(
        'I would like to receive the latest news, updates and offers from BetSquad via email',
        _marketingOptIn, (value) {
      setState(() {
        _marketingOptIn = value;
      });
    });

    var nextButton = FullWidthButton('Next', () {
      if (_dob != null &&
          _firstName.trim().isNotEmpty &&
          _lastName.trim().isNotEmpty &&
          _email.trim().isNotEmpty &&
          _password.trim().isNotEmpty &&
          _confirmPassword.trim().isNotEmpty) {
        if (_password != _confirmPassword) {
          Utility().showErrorAlertDialog(context, 'Passwords do not match',
              'The passwords entered do not match');
          return;
        }
        if (!_termsAndConditionsOptIn) {
          Utility().showErrorAlertDialog(context, 'Terms and Conditions',
              'You must accept the terms and conditions to continue');
          return;
        }

        userDetails["dob"] = _formatter.format(_dob);
        userDetails["firstName"] = _firstName;
        userDetails["lastName"] = _lastName;
        userDetails["email"] = _email;
        userDetails["password"] = _password;
        userDetails["marketingOptIn"] = _marketingOptIn;

        Navigator.pushNamed(context, SignupAddressScreen.ID, arguments: userDetails);
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
