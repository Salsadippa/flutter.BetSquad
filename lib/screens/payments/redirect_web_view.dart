import 'package:betsquad/screens/tab_bar.dart';
import 'package:betsquad/widgets/betsquad_logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RedirectWebViewPage extends StatefulWidget {
  final String redirectUrl;

  const RedirectWebViewPage({Key key, this.redirectUrl}) : super(key: key);

  @override
  _RedirectWebViewPageState createState() => _RedirectWebViewPageState();
}

class _RedirectWebViewPageState extends State<RedirectWebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoAppBar(),
      body: WebView(
        initialUrl: widget.redirectUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) async {
          print('Page finished loading: $url');
          if (url == 'https://api.bet-squad.com/payments/notifications/success') {
            Alert(
              context: context,
              type: AlertType.success,
              title: "Deposit Successful",
              desc: "Please wait up to 2 minutes for the deposited funds to become available",
              buttons: [
                DialogButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pushReplacementNamed(TabBarController.ID),
                  width: 120,
                )
              ],
            ).show();
          } else if (url == 'https://api.bet-squad.com/payments/notifications/failure') {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Deposit Failed",
              desc: "We were not able to make the payment at this time. Please try again.",
              buttons: [
                DialogButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  width: 120,
                )
              ],
            ).show();
          }
        },
      ),
    );
  }
}
