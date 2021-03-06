import 'package:betsquad/api/payment_api.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  double netDepositAmount;

  @override
  void initState() {
    super.initState();
    getNetDepositAmount();
  }

  getNetDepositAmount() async {
    var result = await PaymentApi.netDepositForUser();
    setState(() {
      netDepositAmount = (result['netDeposit'] as num).toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: BetSquadLogoBalanceAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: kGradientBoxDecoration,
              height: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( netDepositAmount != null ?
                      '£${netDepositAmount.toStringAsFixed(2)}' : '',
                      style: GoogleFonts.roboto(color: Colors.white, fontSize: 22),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Net Deposit',
                      style: GoogleFonts.roboto(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: kBetSquadOrange,
              height: 35,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text('Date',
                          style: GoogleFonts.roboto(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Text('Description',
                          textAlign: TextAlign.left, style: GoogleFonts.roboto(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Text(
                        'Amount',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Text(
                        'Balance',
                        style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<Event>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('users')
                    .child(FirebaseAuth.instance.currentUser.uid)
                    .child('transactions')
                    .orderByChild('timestamp')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data.snapshot.value == null) {
                    return Container(
                      decoration: kGradientBoxDecoration,
                    );
                  }

                  List _transactions = [];
                  Map transactions = snapshot.data.snapshot.value;

                  for (int i = 0; i < transactions.length; i++) {
                    Map value = transactions.values.toList()[i];

                    if (value['status'] != 'FAILED') {
                      print(value);

                      var type = value['type'];
                      bool isCredit = [
                        "DEPOSIT",
                        "BET_WON",
                        "BET_EXPIRED",
                        "BET_RESERVED_PLUS",
                        "BET_WITHDRAWN",
                        "BET_"
                            "DECLINED",
                        "NGS_REFUND",
                        "ADMIN_DEPOSIT"
                      ].contains(type);

                      _transactions.add({
                        'amount': value['amount'],
                        'betID': value['betID'],
                        'currency': value['currency'],
                        'detail': value['detail'],
                        'receiver': value['receiver'],
                        'sender': value['sender'],
                        'timestamp': value['timestamp'],
                        'type': value['type'],
                        'isCredit': isCredit,
                        'balance': value['balanceAfter']
                      });
                    }
                  }

                  _transactions.sort((a, b) => Comparable.compare(b['timestamp'], a['timestamp']));

                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      var transaction = _transactions[index];
                      DateTime date = DateTime.fromMillisecondsSinceEpoch(transaction['timestamp']);
                      var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                      return Container(
                        decoration: kGradientBoxDecoration,
                        height: 70,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      date.day.toString(),
                                      style: GoogleFonts.roboto(color: Colors.white),
                                    ),
                                    SizedBox(height: 5),
                                    Text(months[date.month - 1], style: GoogleFonts.roboto(color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (transaction['type'] ?? '').toString().replaceAll('_', ' '),
                                      style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      transaction['detail'] ?? '',
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Text(
                                  '${transaction['isCredit'] ? '+' : '-'} £${(transaction['amount'] as num).toStringAsFixed(2)}',
                                  style: GoogleFonts.roboto(
                                      color: transaction['isCredit'] ? Colors.green : Colors.red, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Text(
                                  '£${transaction['balance'].toStringAsFixed(2)}',
                                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
