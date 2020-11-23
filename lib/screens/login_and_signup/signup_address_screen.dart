import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/tab_bar.dart';
import 'package:betsquad/widgets/betsquad_logo_appbar.dart';
import 'package:betsquad/widgets/full_width_button.dart';
import 'package:betsquad/widgets/text_field_with_title_description.dart';
import 'package:betsquad/widgets/text_field_with_title_desctiption_button.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignupAddressScreen extends StatefulWidget {
  static const String ID = 'signup_address_screen';

  @override
  _SignupAddressScreenState createState() => _SignupAddressScreenState();
}

class _SignupAddressScreenState extends State<SignupAddressScreen> {
  String _postcode = '', _building = '', _street = '', _city = '', _county = '';
  TextEditingController _buildingController = TextEditingController(),
      _streetController = TextEditingController(),
      _cityController = TextEditingController(),
      _countyController = TextEditingController();
  FirebaseServices _firebaseHelper = FirebaseServices();
  var storage = FirebaseStorage.instance;

  _selectedAddress(String address) {
    List parts = address.split(',');
    _building = parts[0].toString().split(' ')[0];
    if (Utility().isNumeric(_building))
      _street = parts[0].toString().replaceAll(_building, '').trim();
    else {
      _building = parts[0].toString().trim();
      _street = parts[1].toString().trim();
    }

    _city = parts[5].toString().trim();
    _county = parts[6].toString().trim();

    _buildingController.text = _building;
    _streetController.text = _street;
    _cityController.text = _city;
    _countyController.text = _county;

    Navigator.pop(context);
  }

  List<Widget> _buildActionSheet(List addresses) {
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

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> userDetails =
        ModalRoute.of(context).settings.arguments;

    var postcodeTextField = TextFieldWithTitleDescButton(
        title: 'Postcode',
        buttonTitle: 'Search',
        onChangeTextField: (value) {
          _postcode = value;
        },
        onPressedButton: () async {
          var addresses = await UsersApi.searchForAddresses(_postcode);

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
        controller: _buildingController,
        title: 'Building',
        onChangeTextField: (String value) {
          _building = value.trim();
        });

    var streetTextField = TextFieldWithTitleDesc(
        controller: _streetController,
        title: 'Street',
        onChangeTextField: (String value) {
          _street = value.trim();
        });
    var cityTextField = TextFieldWithTitleDesc(
        controller: _cityController,
        title: 'City',
        onChangeTextField: (String value) {
          _city = value.trim();
        });
    var countyTextField = TextFieldWithTitleDesc(
        controller: _countyController,
        title: 'County',
        onChangeTextField: (String value) {
          _county = value.trim();
        });

    var skipButton = FullWidthButton('Skip', () async {
      await _firebaseHelper.signUp(userDetails, onSuccess: () {
        print('new user signed up');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TabBarController(),),);
      }, onError: (e) {
        Utility().showErrorAlertDialog(context, 'Error', e.toString());
      });
    });
    var doneButton = FullWidthButton('Done', () async {
      if (_postcode.isNotEmpty &&
          _building.isNotEmpty &&
          _street.isNotEmpty &&
          _city.isNotEmpty &&
          _county.isNotEmpty) {
        userDetails["zip_code"] = _postcode;
        userDetails["building"] = _building;
        userDetails["street"] = _street;
        userDetails["city"] = _city;
        userDetails["county"] = _county;
        userDetails["hidden"] = 0;

        await _firebaseHelper.signUp(userDetails, onSuccess: () {
          print('new user signed up');
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TabBarController(),),);
        }, onError: (e) {
          Utility().showErrorAlertDialog(context, 'Error', e.toString());
        });
      } else {
        Utility().showErrorAlertDialog(context, "Missing fields",
            "Please enter all the fields and try again or skip this step.");
      }
    });

    return Scaffold(
      backgroundColor: Colors.black87,
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
            SizedBox(height: 10),
            skipButton,
            SizedBox(height: 10),
            doneButton
          ],
        ),
      ),
    );
  }
}
