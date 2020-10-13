import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/screens/login_and_signup/login_screen.dart';
import 'package:betsquad/screens/payments/deposit_limits_page.dart';
import 'package:betsquad/screens/payments/formatting_helpers.dart';
import 'package:betsquad/screens/payments/transactions_page.dart';
import 'package:betsquad/screens/profile/delete_account_page.dart';
import 'package:betsquad/screens/profile/self_exclusion_page.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:betsquad/widgets/betsquad_logo_balance_appbar.dart';
import 'package:betsquad/widgets/swipeable_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AccountInfoPage extends StatefulWidget {
  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  List<String> tabs = ['My Details', 'Settings'];
  int initPosition = 0;
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void getProfileDetails() async {
    Map userDetails = await UsersApi.getProfileDetails();
    firstNameController.text = userDetails['firstName'] != null ? userDetails['firstName'] : '';
    lastNameController.text = userDetails['lastName'] != null ? userDetails['lastName'] : '';
    usernameController.text = userDetails['username'] != null ? userDetails['username'] : '';
    emailController.text = userDetails['email'] != null ? userDetails['email'] : '';
    dobController.text = userDetails['dob'] != null ? userDetails['dob'] : '';
    buildingController.text = userDetails['building'] != null ? userDetails['building'] : '';
    streetController.text = userDetails['street'] != null ? userDetails['street'] : '';
    cityController.text = userDetails['city'] != null ? userDetails['city'] : '';
    countyController.text = userDetails['county'] != null ? userDetails['county'] : '';
    postcodeController.text = userDetails['zip_code'] != null ? userDetails['zip_code'] : '';
    phoneNumberController.text = userDetails['customer_phone'] != null ? userDetails['customer_phone'] : '';
  }

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BetSquadLogoBalanceAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            //save profile details
            UsersApi.saveProfileDetails(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                dob: dobController.text,
                street: streetController.text,
                email: emailController.text,
                county: countyController.text,
                city: cityController.text,
                building: buildingController.text,
                phoneNumber: phoneNumberController.text,
                username: usernameController.text,
                postcode: postcodeController.text);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: kGradientBoxDecoration,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 53,
                    backgroundColor: kBetSquadOrange,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('images/user_placeholder.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: CustomTabView(
                initPosition: initPosition,
                itemCount: tabs.length,
                labelSpacing: 50,
                tabBuilder: (context, index) => Tab(text: tabs[index]),
                pageBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Scaffold(
                        body: Container(
                          decoration: kGradientBoxDecoration,
                          child: ListView(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'First Name',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: firstNameController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Last Name',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: lastNameController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Username',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Email',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        readOnly: true,
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'D.O.B',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: dobController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          new LengthLimitingTextInputFormatter(8),
                                          new BirthdayInputFormatter()
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Building',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: buildingController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Street',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: streetController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'City',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: cityController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'County',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: countyController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Postcode',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: postcodeController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        'Phone Number',
                                        style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        style: GoogleFonts.roboto(color: Colors.white),
                                        controller: phoneNumberController,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                color: kBetSquadOrange,
                                child: FlatButton(
                                  child: Text('Log Out', style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),),
                                  onPressed: () async {
                                    await FirebaseServices().signOut();
                                    Navigator.of(context, rootNavigator: true).pushReplacement(
                                      MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    case 1:
                      return Scaffold(
                          body: Container(
                        decoration: kGradientBoxDecoration,
                        child: ListView(
                          children: [
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => CupertinoActionSheet(
                                    title: Text('Please gamble responsibly.'),
                                    actions: [
                                      CupertinoActionSheetAction(
                                        child: Text('Delete Account', style: GoogleFonts.roboto(color: Colors.red),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DeleteAccountPage();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text('Self Exclusion', style: GoogleFonts.roboto(color: Colors.black),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return SelfExclusionPage();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text('Set Deposit Limits', style: GoogleFonts.roboto(color: Colors
                                            .black),),
                                        onPressed: () {
                                          Navigator.of(context).pop();

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DepositLimitsPage();
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Responsible Gambling',
                                      style: GoogleFonts.roboto(color: Colors.white),
                                    ),
                                    Icon(Icons.chevron_right, color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              decoration: kGradientBoxDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Notifications',
                                    style: GoogleFonts.roboto(color: Colors.white),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.white)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TransactionsPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 50,
                                decoration: kGradientBoxDecoration,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Transaction History',
                                      style: GoogleFonts.roboto(color: Colors.white),
                                    ),
                                    Icon(Icons.chevron_right, color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              decoration: kGradientBoxDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Help',
                                    style: GoogleFonts.roboto(color: Colors.white),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.white)
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 50,
                              decoration: kGradientBoxDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Terms and Conditions',
                                    style: GoogleFonts.roboto(color: Colors.white),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.white)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                    default:
                      return Scaffold();
                  }
                },
                onPositionChange: (index) {
                  initPosition = index;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
