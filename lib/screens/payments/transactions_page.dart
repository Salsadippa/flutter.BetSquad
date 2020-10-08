import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List _transactions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  getTransactions() async {
    setState(() {
      isLoading = true;
    });
    List transactions = await UsersApi.getUsersTransactions();
    print(transactions);
    setState(() {
      _transactions = transactions.reversed.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: BetSquadLogoBalanceAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  var transaction = _transactions[index];
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(transaction['timestamp']);
                  var months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"];
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
                          flex: 3,
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
                              '${transaction['isCredit'] ? '+' : '-'} £${(transaction['amount'] as num)
                                  .toStringAsFixed(2)}',
                              style: GoogleFonts.roboto(color: transaction['isCredit'] ? Colors.green : Colors.red,
                                  fontSize:
                              15),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Text(
                              '£${(transaction['balance'] as num).toStringAsFixed(2)}',
                              style: GoogleFonts.roboto(color: Colors.white, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
