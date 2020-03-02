import 'package:betsquad/custom_widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/custom_widgets/full_width_button.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_description.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_desctiption_button.dart';
import 'package:flutter/material.dart';

class SignupAddressScreen extends StatefulWidget {
  static String id = 'signup_address_screen';

  @override
  _SignupAddressScreenState createState() => _SignupAddressScreenState();
}

class _SignupAddressScreenState extends State<SignupAddressScreen> {
  String postcode, building, street, city, county;

  @override
  Widget build(BuildContext context) {

    var postcodeTextField = TextFieldWithTitleDescButton(title: 'Postcode', buttonTitle: 'Search', onChangeTextField: (value){ print("hello");}, onPressedButton: (){print("bye");});

    var buildingTextField = TextFieldWithTitleDesc(
        title: 'Building',
        onChangeTextField: (value) {
          building = value;
        });

    var streetTextField = TextFieldWithTitleDesc(
        title: 'Street',
        onChangeTextField: (value) {
          street = value;
        });
    var cityTextField = TextFieldWithTitleDesc(
        title: 'City',
        onChangeTextField: (value) {
          city = value;
        });
    var countyTextField = TextFieldWithTitleDesc(
        title: 'Country',
        onChangeTextField: (value) {
          county = value;
        });

    var skipButton = FullWidthButton('Skip', () {
      print("skip");
    });
    var doneButton = FullWidthButton('Done', () {
      print("done");
    });

    return Scaffold(
//      backgroundColor: Colors.black,
      appBar: BetSquadLogoAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
           postcodeTextField,
            buildingTextField,
            streetTextField,
            cityTextField,
            countyTextField,
            skipButton,
            doneButton,

          ],
        ),
      ),
    );
  }
}
