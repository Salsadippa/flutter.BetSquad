import 'package:betsquad/api/payment_api.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/payments/deposit_limits_page.dart';
import 'package:betsquad/screens/payments/redirect_web_view.dart';
import 'package:betsquad/string_utils.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/utilities/utility.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../alert.dart';
import 'formatting_helpers.dart';

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  var _loading = false;
  double _amount = 0.0;
  String _cardNumber,
      _expiry,
      _cvv,
      _firstName,
      _lastName,
      _email,
      _building,
      _street,
      _city,
      _county,
      _postcode,
      _phoneNumber,
      _dob;

  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      usernameController = TextEditingController(),
      emailController = TextEditingController(),
      dobController = TextEditingController(),
      buildingController = TextEditingController(),
      streetController = TextEditingController(),
      cityController = TextEditingController(),
      countyController = TextEditingController(),
      postcodeController = TextEditingController(),
      phoneNumberController = TextEditingController();

  void getProfileDetails() async {
    Map userDetails = await UsersApi.getProfileDetails();
    firstNameController.text = userDetails['firstName'] != null ? userDetails['firstName'] : '';
    _firstName = userDetails['firstName'] != null ? userDetails['firstName'] : '';

    lastNameController.text = userDetails['lastName'] != null ? userDetails['lastName'] : '';
    _lastName = userDetails['lastName'] != null ? userDetails['lastName'] : '';

    emailController.text = userDetails['email'] != null ? userDetails['email'] : '';
    _email = userDetails['email'] != null ? userDetails['email'] : '';

    dobController.text = userDetails['dob'] != null ? userDetails['dob'] : '';
    _dob = userDetails['dob'] != null ? userDetails['dob'] : '';

    buildingController.text = userDetails['building'] != null ? userDetails['building'] : '';
    _building = userDetails['building'] != null ? userDetails['building'] : '';

    streetController.text = userDetails['street'] != null ? userDetails['street'] : '';
    _street = userDetails['street'] != null ? userDetails['street'] : '';

    cityController.text = userDetails['city'] != null ? userDetails['city'] : '';
    _city = userDetails['city'] != null ? userDetails['city'] : '';

    countyController.text = userDetails['county'] != null ? userDetails['county'] : '';
    _county = userDetails['county'] != null ? userDetails['county'] : '';

    postcodeController.text = userDetails['zip_code'] != null ? userDetails['zip_code'] : '';
    _postcode = userDetails['zip_code'] != null ? userDetails['zip_code'] : '';

    phoneNumberController.text = userDetails['customer_phone'] != null ? userDetails['customer_phone'] : '';
    _phoneNumber = userDetails['customer_phone'] != null ? userDetails['customer_phone'] : '';
  }

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText2,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText3,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText4,
        ),
      ],
    );
  }

  @override
  void initState() {
    getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          decoration: kGradientBoxDecoration,
          child: KeyboardActions(
            config: _buildConfig(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    decoration: kGradientBoxDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'iTech Gaming Ltd.\nGreenville Court, Britwell Road\nBurnham, Bucks\nSL1 8DF',
                          style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 30,
                          child: Image.asset('images/payment-logos.png', height: 80, fit: BoxFit.contain),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('AMOUNT', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        focusNode: _nodeText1,
                        controller: currencyTextFieldController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '£0.00',
                            hintStyle: GoogleFonts.roboto(color: Colors.white)),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _amount = currencyTextFieldController.doubleValue;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text('Your transactions will show on your account as BetSquad +44 (0) 203 289 6518',
                        style: GoogleFonts.roboto(color: Colors.grey)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Your account will be debited £${(((_amount * 0.0205) + 0.10) + _amount).toStringAsFixed
                      (2)}',
                        style: GoogleFonts.roboto(color: Colors.grey)),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('CARD DETAILS', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        focusNode: _nodeText2,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            labelText: 'Card Number',
                            labelStyle: GoogleFonts.roboto(color: kBetSquadOrange)),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          new LengthLimitingTextInputFormatter(16),
                          new CardNumberInputFormatter()
                        ],
                        onChanged: (value) {
                          setState(() {
                            _cardNumber = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: GoogleFonts.roboto(color: Colors.white),
                        focusNode: _nodeText3,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Expiry Date',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _expiry = value;
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          new LengthLimitingTextInputFormatter(4),
                          new CardMonthInputFormatter()
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        focusNode: _nodeText4,
                        style: GoogleFonts.roboto(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'CVV',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          new LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _cvv = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text('CARDHOLDER DETAILS', style: GoogleFonts.roboto(color: Colors.white)),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: firstNameController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'First Name',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: lastNameController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Last Name',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        readOnly: true,
                        controller: emailController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Email Address',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: buildingController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Building',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _building = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: streetController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Street',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _street = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: cityController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'City',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _city = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: countyController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'County',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _county = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: postcodeController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Postcode',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _postcode = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: phoneNumberController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Phone Number',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _phoneNumber = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    decoration: kGradientBoxDecoration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: dobController,
                        style: GoogleFonts.roboto(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'D.O.B',
                          labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          new LengthLimitingTextInputFormatter(8),
                          new BirthdayInputFormatter()
                        ],
                        onChanged: (value) {
                          setState(() {
                            _dob = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: FlatButton(
                      color: kBetSquadOrange,
                      onPressed: () async {

                        if (StringUtils.isNullOrEmpty(_firstName) ||
                            StringUtils.isNullOrEmpty(_lastName) ||
                            StringUtils.isNullOrEmpty(_email) ||
                            StringUtils.isNullOrEmpty(_building) ||
                            StringUtils.isNullOrEmpty(_street) ||
                            StringUtils.isNullOrEmpty(_city) ||
                            StringUtils.isNullOrEmpty(_county) ||
                            StringUtils.isNullOrEmpty(_postcode) ||
                            StringUtils.isNullOrEmpty(_phoneNumber) ||
                            StringUtils.isNullOrEmpty(_dob)) {
                          Alert.showErrorDialog(context, 'Missing Details', 'Please fill in all details before proceeding');
                          return;
                        }

                        if (_amount < 10.0) {
                          Alert.showErrorDialog(context, '£10 Minimum Deposit', 'You must deposit at least £10');
                          return;
                        }

                        setState(() {
                          _loading = true;
                        });

                        if (!(await Utility().isInTheUk())) {
                          Alert.showErrorDialog(
                              context,
                              'UK Deposits Only',
                              'You are not in the UK or we could not verify your location so you cannot deposit funds. '
                                  'Make sure location access is enabled.');
                          return;
                        }

                        Map res = await UsersApi.checkLimitsLastUpdate();

                        if (res['limitsExist']) {
                          // has set limits

                          //run aml check
                          bool compliant = await UsersApi.complianceCheck();
                          print(compliant);

                          if (compliant) {
                            //deposit limits check
                            Map res = await UsersApi.checkValidDeposit(_amount);

                            print(res);

                            if (res['approved']) {
                              var expirySplit = _expiry.split(new RegExp(r'(\/)'));

                              Map deposit = await PaymentApi.depositFunds(
                                  amount: _amount,
                                  building: _building,
                                  cardNumber: _cardNumber,
                                  expiryMonth: expirySplit[0],
                                  expiryYear: expirySplit[1],
                                  city: _city,
                                  county: _county,
                                  email: _email,
                                  firstName: _firstName,
                                  lastName: _lastName,
                                  phoneNumber: _phoneNumber,
                                  postcode: _postcode,
                                  street: _street,
                                  dob: _dob,
                                  cvv: _cvv);

                              print(deposit);

                              setState(() {
                                _loading = false;
                              });

                              if (deposit['body']["status"] == "declined" || deposit['body']["status"] == "error") {
                                Alert.showErrorDialog(context, 'Cannot make deposit',
                                    'This deposit failed. Please check your details and try again');
                              } else {
                                String redirectUrl = deposit['body']['redirect_url'];
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RedirectWebViewPage(
                                      redirectUrl: redirectUrl,
                                    ),
                                  ),
                                );
                              }
                              
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              Alert.showErrorDialog(context, 'Cannot make deposit',
                                  'This deposit would take you over your deposit limits');
                            }
                          } else {
                            setState(() {
                              _loading = false;
                            });
                            Alert.showErrorDialog(context, 'Cannot make deposit',
                                'You have failed our compliance check. Please contact info@bet-squad.com');
                          }
                        } else {
                          // has not set limits
                          print("must set limits");
                          setState(() {
                            _loading = false;
                          });

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DepositLimitsPage()),
                          );
                        }
                      },
                      child: Text(
                        'Done',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 19),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
