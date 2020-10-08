import 'package:betsquad/api/payment_api.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/payments/deposit_limits_page.dart';
import 'package:betsquad/string_utils.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../alert.dart';
import 'formatting_helpers.dart';

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(),
      body: Container(
        decoration: kGradientBoxDecoration,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('AMOUNT', style: GoogleFonts.roboto(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text('Please note that there is a 10p + 2.05% charge for deposits',
                    style: GoogleFonts.roboto(color: Colors.grey)),
              ),
              Container(
                height: 55,
                decoration: kGradientBoxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: currencyTextFieldController,
                    style: GoogleFonts.roboto(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '£0.00',
                        hintStyle: GoogleFonts.roboto(color: Colors.white)),
                    onChanged: (value) {
                      setState(() {
                        _amount = currencyTextFieldController.doubleValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('CARD DETAILS', style: GoogleFonts.roboto(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text('Your transactions will show on your account as BetSquad +44 (0) 203 289 6518',
                    style: GoogleFonts.roboto(color: Colors.grey)),
              ),
              Container(
                height: 55,
                decoration: kGradientBoxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
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

                    Map res = await UsersApi.checkLimitsLastUpdate();
                    print(res);

                    if (res['limitsExist']) {
                      // has set limits

                      //run aml check
                      Map res = await UsersApi.checkUserHasAmlCheck();
                      print(res);

                      if (res['amlCheck']) {

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

                          String redirectUrl = deposit['body']['redirect_url'];
                          await _launchURL(redirectUrl);
                        }
                      } else {
                        //no aml check flag

                      }
                    } else {
                      // has not set limits
                      print("must set limits");

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
    );
  }
}
