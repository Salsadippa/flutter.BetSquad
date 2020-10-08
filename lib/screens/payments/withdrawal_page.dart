import 'package:betsquad/api/payment_api.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:betsquad/styles/constants.dart';

import 'formatting_helpers.dart';

class WithdrawalPage extends StatefulWidget {
  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  double _amount;
  String _cardNumber, _expiry, _cvv;
  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(thousandSymbol: ',', rightSymbol: '£', decimalSymbol: '.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
                child: Text('Please note that there is a £1 fee for withdrawals',
                    style: GoogleFonts.roboto(color: Colors.grey)),
              ),
              Container(
                height: 55,
                decoration: kGradientBoxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: currencyTextFieldController,
                    onChanged: (value) {
                      setState(() {
                        _amount = currencyTextFieldController.doubleValue;
                      });
                    },
                    style: GoogleFonts.roboto(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: '£0.00',
                        hintStyle: GoogleFonts.roboto(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text('CARD DETAILS', style: GoogleFonts.roboto(color: Colors.white)),
              ),
              Container(
                height: 55,
                decoration: kGradientBoxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _cardNumber = value;
                      });
                    },
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
                      LengthLimitingTextInputFormatter(16),
                      CardNumberInputFormatter()
                    ],
                    // controller: numberController,
                    onSaved: (String value) {},
//                validator: CardUtils.validateCardNumWithLuhnAlgorithm,
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
                    onChanged: (value) {
                      setState(() {
                        _expiry = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      labelText: 'Expiry Date',
                      labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                    ),
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
                    onChanged: (value) {
                      setState(() {
                        _cvv = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      labelText: 'CVV',
                      labelStyle: GoogleFonts.roboto(color: kBetSquadOrange),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
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
                    var expirySplit = _expiry.split(new RegExp(r'(\/)'));
                    await PaymentApi.withdrawFunds(
                        amount: _amount,
                        cvv: _cvv,
                        cardNumber: _cardNumber,
                        expiryMonth: expirySplit[0],
                        expiryYear: expirySplit[1]);
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
