import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/api/users_api.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SelectOpponentScreen extends StatefulWidget {
  final Map alreadyInvited;
  final List alreadySelected;
  final bool multipleSelection;

  static const String ID = 'select_opponent_screen';

  SelectOpponentScreen({this.alreadyInvited = const {}, this.multipleSelection = false, this.alreadySelected = const
  []});

  @override
  _SelectOpponentScreenState createState() => _SelectOpponentScreenState();
}

class _SelectOpponentScreenState extends State<SelectOpponentScreen> {
  List<ListItem<Map<String, dynamic>>> allUsers = [];
  var selectedUsers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getData();
    print(widget.alreadySelected);
  }

  getData() async {
    setState(() {
      _loading = true;
    });
    Map users = await UsersApi.getAllUsers();
    var opponents = users.values.toList();
    opponents.sort((a, b) => a['username'].toString().toLowerCase().compareTo(b['username'].toString().toLowerCase()));
    opponents.removeWhere((element) => widget.alreadyInvited.keys.contains(element['uid']));
    setState(() {
      allUsers = List.generate(opponents.length, (index) {
        ListItem<Map<String,dynamic>> item = ListItem(opponents[index]);
        bool selected = (widget.alreadySelected.contains(opponents[index]['uid']));
        if (selected){
          selectedUsers.add(opponents[index]);
        }
        item.isSelected = selected;
        return item;
      });
      allUsers.removeWhere((element) => !element.data.containsKey('username'));
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.multipleSelection != null && widget.multipleSelection
              ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, selectedUsers);
                    },
                    child: Center(
                        child: Text(
                      'Done',
                      style: TextStyle(fontSize: 15),
                    )),
                  ),
                )
              : Text('')
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          color: Colors.black87,
          child: ListView.builder(
            itemCount: allUsers.length,
            itemBuilder: (context, index) {
              var user = allUsers[index].data;
              print(user['image']);
              return ListTile(
                key: ObjectKey(user),
                title: Text(
                  user['username'] ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                leading: CircleAvatar(
                  backgroundColor: kBetSquadOrange,
                  radius: 22,
                  child: CircleAvatar(
                    backgroundImage: user['image'] != null && user['image'] != ''
                        ? NetworkImage(user['image'])
                        : kUserPlaceholderImage,
                    radius: 20,
                  ),
                ),
                trailing: allUsers[index].isSelected
                    ? Icon(
                        Icons.check,
                        color: kBetSquadOrange,
                      )
                    : null,
                onTap: () {
                  if (widget.multipleSelection) {
                    setState(() {
                      if (allUsers[index].isSelected) {
                        selectedUsers.remove(user);
                      } else {
                        selectedUsers.add(user);
                      }
                      allUsers[index].isSelected = !allUsers[index].isSelected;
                    });
                  } else {
                    Navigator.pop(context, user);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}
