import 'dart:convert';
import 'package:betsquad/api/users_api.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../alert.dart';

class EditSquadPage extends StatefulWidget {
  final String squadId;

  static const ID = 'edit_squad_page';

  const EditSquadPage({Key key, this.squadId}) : super(key: key);

  @override
  _EditSquadPageState createState() => _EditSquadPageState();
}

class _EditSquadPageState extends State<EditSquadPage> {
  Map allUsers = {};
  Map squad = {};
  bool isLoadingSquad = false;
  bool isLoadingUsers = false;
  TextEditingController textEditingController = TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
//      squad['image'] = image;
    });
  }

  fetchSquadInfo() async {
    setState(() {
      isLoadingSquad = true;
    });
    var squadInfo = await UsersApi.getSquadInfo(widget.squadId);
    setState(() {
      squad = squadInfo;
      isLoadingSquad = false;
    });
    textEditingController.text = squad['name'];
  }

  fetchAllUsers() async {
    setState(() {
      isLoadingUsers = true;
    });
    var res = await UsersApi.getAllUsers();
    setState(() {
      allUsers = res;
      isLoadingUsers = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
    fetchSquadInfo();
  }

  @override
  Widget build(BuildContext context) {
    List allUsersList = allUsers.values.toList();

    List withUserIds = (squad['with'] as Map ?? {}).values.map((e) => e['uid']).toList();

    void updateWith(user) {
      if (withUserIds.contains(user['uid'])) {
        print("already contains");
        setState(() {
          (squad['with'] as Map).removeWhere((key, value) => key == user['uid']);
        });
      } else {
        print("does not contain");
        setState(() {
          (squad['with'] as Map)[user['uid']] = {
            'uid': user['uid'],
            'username': user['username']
          };
        });
      }
    }

    bool isLoading = isLoadingSquad || isLoadingUsers;

    var betSquadLogo = Image.asset(
      'images/app_bar_logo.png',
      fit: BoxFit.contain,
      height: 32,
    );

    var appBar = AppBar(
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [betSquadLogo],
      ),
      actions: [
        GestureDetector(
          onTap: () async {
            print(json.encode(squad));
            setState(() {
              isLoading = true;
            });
            Map res = await UsersApi.setSquadInfo(widget.squadId, squad);
            if (res['result'] == 'success') {
              Alert.showSuccessDialog(
                  context, 'Squad Updated', res['message']);
            }
            print(res);
            setState(() {
              isLoading = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
                child: Text(
              'Done',
              style: GoogleFonts.roboto(fontSize: 18),
            )),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          decoration: kGradientBoxDecoration,
          child: isLoading
              ? Container(color: Colors.black)
              : SingleChildScrollView(
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
                                backgroundImage: squad['image'] == null || squad['image'].toString().trim().isEmpty
                                    ? AssetImage('images/ball.png')
                                    : FileImage(squad['image']),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: TextField(
                          controller: textEditingController,
                          style: GoogleFonts.roboto(color: Colors.black, fontSize: 17),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10.0),
                            //here your padding
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            filled: true,
                            fillColor: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              squad['name'] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 50),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          var user = allUsersList[index];
                          return Container(
                            decoration: kGradientBoxDecoration,
                            child: ListTile(
                              onTap: () {
                                updateWith(user);
                              },
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: kBetSquadOrange,
                                child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: user['image'] == null || user['image'].toString().trim().isEmpty
                                        ? AssetImage('images/user_placeholder'
                                            '.png')
                                        : NetworkImage(user['image'])),
                              ),
                              title: Text(
                                user['username'],
                                style: GoogleFonts.roboto(color: Colors.white),
                              ),
                              subtitle: Text((user['firstName'] ?? '') + ' ' + (user['lastName'] ?? ''),
                                  style: GoogleFonts.roboto(color: Colors.white)),
                              trailing: withUserIds.contains(user['uid'].toString())
                                  ? Icon(
                                      Icons.check,
                                      color: kBetSquadOrange,
                                    )
                                  : null,
                            ),
                          );
                        },
                        itemCount: allUsersList.length,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
