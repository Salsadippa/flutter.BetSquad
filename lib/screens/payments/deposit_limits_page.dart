import 'package:betsquad/api/payment_api.dart';
import 'package:betsquad/string_utils.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../alert.dart';

class DepositLimitsPage extends StatefulWidget {
  @override
  _DepositLimitsPageState createState() => _DepositLimitsPageState();
}

class _DepositLimitsPageState extends State<DepositLimitsPage> {
  int option1Value = 25, option2Value = 50, option3Value = 100;
  bool _option1 = false, _option2 = false, _option3 = false, _otherOption = false;
  bool weekOption = false, monthOption = false;
  bool noLimits = false;
  double _otherAmount = 0.0;
  int lastUpdatedAt;
  final f = new DateFormat('dd-MM-yyyy hh:mm');
  bool _isLoading = false;

  CurrencyTextFieldController currencyTextFieldController =
      CurrencyTextFieldController(rightSymbol: "£", decimalSymbol: ".", thousandSymbol: ",");

  @override
  void initState() {
    super.initState();
    getDepositLimits();
  }

  void getDepositLimits() async {
    setState(() {
      _isLoading = true;
    });
    Map userLimits = await PaymentApi.getDepositLimits();
    print(userLimits);
    if (userLimits['lastLimitUpdate'] != null) {
      setState(() {
        lastUpdatedAt = userLimits['lastLimitUpdate'];
      });
    }
    if (userLimits['limitPeriod'] != null) {
      setState(() {
        if (userLimits['limitPeriod'] == "week") {
          setState(() {
            weekOption = true;
            monthOption = false;
          });
        } else if (userLimits['limitPeriod'] == "month") {
          setState(() {
            monthOption = true;
            weekOption = false;
          });
        }
      });
    }
    if (userLimits['limitAmount'] != null) {
      var amount = (userLimits['limitAmount'] as num).toDouble();
      if (amount == option1Value) {
        setState(() {
          _option1 = true;
          _option2 = false;
          _option3 = false;
          _otherOption = false;
          noLimits = false;
        });
      } else if (amount == option2Value) {
        setState(() {
          _option1 = false;
          _option2 = true;
          _option3 = false;
          _otherOption = false;
          noLimits = false;
        });
      } else if (amount == option3Value) {
        setState(() {
          _option1 = false;
          _option2 = false;
          _option3 = true;
          _otherOption = false;
          noLimits = false;
        });
      } else {
        setState(() {
          _option1 = false;
          _option2 = false;
          _option3 = false;
          _otherOption = true;
          currencyTextFieldController.text = amount.toStringAsFixed(2);
          noLimits = false;
        });
      }
    } else if (userLimits['lastLimitUpdate'] != null) {
      setState(() {
        _option1 = false;
        _option2 = false;
        _option3 = false;
        _otherOption = false;
        noLimits = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BetSquadLogoBalanceAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: kGradientBoxDecoration,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Text(
                  'I want to bet a maximum of: ',
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _option1 = true;
                          _option2 = false;
                          _option3 = false;
                          _otherOption = false;
                          noLimits = false;
                        });
                      },
                      color: _option1 ? Colors.green : Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '£$option1Value',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _option1 = false;
                          _option2 = true;
                          _option3 = false;
                          _otherOption = false;
                          noLimits = false;
                        });
                      },
                      color: _option2 ? Colors.green : Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '£$option2Value',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _option1 = false;
                          _option2 = false;
                          _option3 = true;
                          _otherOption = false;
                        });
                      },
                      color: _option3 ? Colors.green : Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '£$option3Value',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _option1 = false;
                            _option2 = false;
                            _option3 = false;
                            _otherOption = true;
                            _otherAmount = currencyTextFieldController.doubleValue;
                            noLimits = false;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          filled: true,
                          fillColor: _otherOption ? Colors.green : Colors.black54,
                          hintText: 'Other',
                          hintStyle: GoogleFonts.roboto(color: Colors.white, fontSize: 19),
                        ),
                        controller: currencyTextFieldController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'every: ',
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          weekOption = true;
                          monthOption = false;
                          noLimits = false;
                        });
                      },
                      color: weekOption ? Colors.green : Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'week',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          weekOption = false;
                          monthOption = true;
                          noLimits = false;
                        });
                      },
                      color: monthOption ? Colors.green : Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'month',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'or',
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _option1 = false;
                          _option2 = false;
                          _option3 = false;
                          _otherOption = false;
                          weekOption = false;
                          monthOption = false;
                          noLimits = true;
                        });
                      },
                      color: noLimits ? Colors.green : Colors.black54,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'I do not want any limits',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                SizedBox(
                  child: FlatButton(
                    onPressed: () async {
                      if (noLimits) {
                        print("no limits");
                        var res = await PaymentApi.updateDepositLimits("none", '');
                        print(res);
                        if (res['result'] == 'success') {
                          print("success");
                          Alert.showSuccessDialog(context, 'Limits Updated', res['message']);
                          setState(() {
                            lastUpdatedAt = DateTime.now().millisecondsSinceEpoch;
                          });
                        } else {
                          Alert.showErrorDialog(context, 'Error Updating Limits', res['message']);
                        }
                        return;
                      }

                      double limitAmount = _option1
                          ? option1Value.toDouble()
                          : _option2
                              ? option2Value.toDouble()
                              : _option3
                                  ? option3Value.toDouble()
                                  : _otherOption
                                      ? _otherAmount
                                      : 0.0;

                      if (limitAmount == 0.0) {
                        print("no limit amount");
                        return;
                      }

                      String timePeriod = weekOption
                          ? 'week'
                          : monthOption
                              ? 'month'
                              : '';

                      if (StringUtils.isNullOrEmpty(timePeriod)) {
                        print("no time period");
                        return;
                      }

                      var res = await PaymentApi.updateDepositLimits(limitAmount.toString(), timePeriod);
                      print(res);
                      if (res['result'] == 'success') {
                        print("success");
                        Alert.showSuccessDialog(context, 'Limits Updated', res['message']);
                        setState(() {
                          lastUpdatedAt = DateTime.now().millisecondsSinceEpoch;
                        });
                      } else {
                        Alert.showErrorDialog(context, 'Error Updating Limits', res['message']);
                      }
                    },
                    child: Text(
                      'Update Limits',
                      style: GoogleFonts.roboto(fontSize: 20, color: kBetSquadOrange),
                    ),
                  ),
                ),
                Text(
                  'Last Updated: ${lastUpdatedAt == null ? 'Never' : f.format(DateTime.fromMillisecondsSinceEpoch(lastUpdatedAt))}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
