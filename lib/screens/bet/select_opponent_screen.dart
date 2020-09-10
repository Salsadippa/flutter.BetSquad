import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:betsquad/api/users_api.dart';

class SelectOpponentScreen extends StatefulWidget {
  static const String ID = 'select_opponent_screen';

  @override
  _SelectOpponentScreenState createState() => _SelectOpponentScreenState();
}

class _SelectOpponentScreenState extends State<SelectOpponentScreen> {
  List<ListItem<Map<String,dynamic>>> allUsers = [];
  var selectedUsers = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Map users = await UsersApi.getAllUsers();
    var opponents = users.values.toList();
    opponents.sort((a, b ) => a['username'].toString().toLowerCase().compareTo(b['username'].toString().toLowerCase()));
    setState(() {
      allUsers = List.generate(opponents.length, (index) => ListItem(opponents[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool multipleSelection = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        actions: [
          multipleSelection != null && multipleSelection
              ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: (){
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
      body: Container(
        color: Colors.black87,
        child: ListView.builder(
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            var user = allUsers[index].data;
            return ListTile(
              key: ObjectKey(user),
              title: Text(
                user['username'],
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
                if (multipleSelection) {
                  setState(() {
                    print("change");
                    print(allUsers[index].isSelected);
                    if (allUsers[index].isSelected) {
                      selectedUsers.remove(user);
                    } else {
                      selectedUsers.add(user);
                    }
                    allUsers[index].isSelected = !allUsers[index].isSelected;
                    print(selectedUsers.length);
                  });
                } else {
                  Navigator.pop(context, user);
                }
              },
            );
          },
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
