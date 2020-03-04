import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/custom_widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/custom_widgets/full_width_button.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_description.dart';
import 'package:betsquad/custom_widgets/text_field_with_title_desctiption_button.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupAddressScreen extends StatefulWidget {
  static const String id = 'signup_address_screen';

  @override
  _SignupAddressScreenState createState() => _SignupAddressScreenState();
}

class _SignupAddressScreenState extends State<SignupAddressScreen> {
  String postcode = '', building = '', street = '', city = '', county = '';
  TextEditingController buildingController = TextEditingController(),
      streetController = TextEditingController(),
      cityController = TextEditingController(),
      countyController = TextEditingController();
  FirebaseServices firebaseHelper = FirebaseServices();

  _selectedAddress(String address) {
    List parts = address.split(',');
    building = parts[0].toString().split(' ')[0];
    if (Utility().isNumeric(building))
      street = parts[0].toString().replaceAll(building, '').trim();
    else {
      building = parts[0].toString().trim();
      street = parts[1].toString().trim();
    }

    city = parts[5].toString().trim();
    county = parts[6].toString().trim();

    buildingController.text = building;
    streetController.text = street;
    cityController.text = city;
    countyController.text = county;

    Navigator.pop(context);
  }

  List<Widget> _buildActionSheet(List addresses) {
    final Map<String, Object> userDetails =
        ModalRoute.of(context).settings.arguments;

    List<Widget> widgets = [];
    for (var i = 0; i < addresses.length; i++) {
      var action = CupertinoActionSheetAction(
        child: Text(addresses[i].toString().trim().replaceAll(' , ,', '')),
        onPressed: () {
          _selectedAddress(addresses[i]);
        },
      );
      widgets.add(action);
    }
    return widgets;
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> userDetails =
        ModalRoute.of(context).settings.arguments;

    var postcodeTextField = TextFieldWithTitleDescButton(
        title: 'Postcode',
        buttonTitle: 'Search',
        onChangeTextField: (value) {
          postcode = value;
        },
        onPressedButton: () async {
          var addresses = await UsersApi().searchForAddresses(postcode);

          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Select your address'),
                message: const Text('Please select your address from the list'),
                actions: _buildActionSheet(addresses),
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                )),
          );
        });

    var buildingTextField = TextFieldWithTitleDesc(
        controller: buildingController,
        title: 'Building',
        onChangeTextField: (String value) {
          building = value.trim();
        });

    var streetTextField = TextFieldWithTitleDesc(
        controller: streetController,
        title: 'Street',
        onChangeTextField: (String value) {
          street = value.trim();
        });
    var cityTextField = TextFieldWithTitleDesc(
        controller: cityController,
        title: 'City',
        onChangeTextField: (String value) {
          city = value.trim();
        });
    var countyTextField = TextFieldWithTitleDesc(
        controller: countyController,
        title: 'County',
        onChangeTextField: (String value) {
          county = value.trim();
        });

    var skipButton = FullWidthButton('Skip', () {
      print("skip");
    });
    var doneButton = FullWidthButton('Done', () async {
      if (postcode.isNotEmpty &&
          building.isNotEmpty &&
          street.isNotEmpty &&
          city.isNotEmpty &&
          county.isNotEmpty) {

        userDetails["postcode"] = postcode;
        userDetails["building"] = building;
        userDetails["street"] = street;
        userDetails["city"] = city;
        userDetails["county"] = county;

        try {
          var newUser = await firebaseHelper.signUp(userDetails);
          if (newUser != null) {
            print("new user created");
          }
        } catch (e) {
          Utility().showErrorAlertDialog(context, 'Error creating account', e.toString());
          print("ERRORR: " + e.toString());
        }

      } else {
        Utility().showErrorAlertDialog(context, "Missing fields",
            "Please enter all the fields and try again or skip this step.");
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey,
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
