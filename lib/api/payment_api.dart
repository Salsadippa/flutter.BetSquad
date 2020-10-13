import 'dart:convert';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class PaymentApi {

  static Future<Map> withdrawFunds({double amount, String cardNumber, String expiryMonth, String expiryYear, String
  cvv}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.PAYMENT_SERVER);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();

    Map profileDetails = await UsersApi.getProfileDetails();
    print(profileDetails);
    
    var params = {
      'usage': '',
      'description': 'deposit',
      'amount': amount.toString(),
      'currency': 'GBP',
      'card_holder': profileDetails['firstName'] + ' ' + profileDetails['lastName'],
      'card_number': cardNumber.replaceAll(' ', ''),
      'cvv_number': cvv,
      'expiration_month': expiryMonth,
      'expiration_year': "20" + expiryYear.toString(),
      'customer_email': profileDetails['email'],
      'customer_phone': profileDetails['customer_phone'],
      'billing_address': json.encode({
        'first_name': profileDetails['firstName'],
        'last_name': profileDetails['lastName'],
        'address1': profileDetails['building'] + ' ' + profileDetails['street'] + ' ' + profileDetails['city'] + ' ' +
            profileDetails['county'],
        'city': profileDetails['city'],
        'zip_code': profileDetails['zip_code'],
        'country': 'GB'
      }),
      'auth': idToken
    };

    print(params);

    // return {};

    Response result = await networkHelper.post('https://api.bet-squad.com/payments/withdraw/new', {}, params);
    print(result.statusCode);
    print(result.body);
    return json.decode(result.body);

  }

  static Future<Map> depositFunds({double amount, String firstName, String lastName, String cardNumber, String
  expiryMonth, String expiryYear, String email, String phoneNumber, String building, String street, String city,
      String county, String postcode, String dob, String cvv}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.PAYMENT_SERVER);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    var params = {
      'usage': '',
      'description': 'deposit',
      'amount': amount.toString(),
      'currency': 'GBP',
      'card_holder': firstName + ' ' + lastName,
      'card_number': cardNumber.replaceAll(' ', ''),
      'cvv_number': cvv,
      'expiration_month': expiryMonth,
      'expiration_year': "20" + expiryYear.toString(),
      'customer_email': email,
      'customer_phone': phoneNumber,
      'billing_address': json.encode({
        'first_name': firstName,
        'last_name': lastName,
        'address1': building + ' ' + street + ' ' + city + ' ' + county,
        'city': city,
        'zip_code': postcode,
        'country': 'GB'
      }),
      'auth': idToken
    };

    Response result = await networkHelper.post('https://api.bet-squad.com/payments/payment/new', {}, params);
    print(result.statusCode);
    print(result.body);
    return json.decode(result.body);
  }

  static Future<Map> updateDepositLimits(String newLimit, String period) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String,String> queryParameters = {
      'userID': user.uid,
      'newLimit': newLimit,
      'newPeriod': period,
      'idToken': idToken
    };
    var response = await networkHelper.getJSON('/updateLimits', queryParameters);
    return response;
  }

  static Future<Map> getDepositLimits() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String,String> queryParameters = {
      'senderId': user.uid,
      'idToken': idToken
    };
    var response = await networkHelper.getJSON('/getDepositLimits', queryParameters);
    print(response);
    return response;
  }

}
