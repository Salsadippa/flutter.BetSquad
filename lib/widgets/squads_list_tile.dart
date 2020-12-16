import 'package:betsquad/screens/profile/edit_squad_page.dart';
import 'package:betsquad/styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SquadListTile extends StatelessWidget {
  final Map squad;
  final String id;

  const SquadListTile({
    Key key,
    this.squad,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kGradientBoxDecoration,
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: kBetSquadOrange,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: squad['image'] != null && squad['image'].toString().isNotEmpty
                ? NetworkImage(squad['image'])
                : AssetImage('images/ball.png'),
          ),
        ),
        trailing: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditSquadPage(squadId: id),
                ),
              );
            },
            child: Icon(Icons.edit, color: kBetSquadOrange)),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(squad['title'], style: GoogleFonts.roboto(color: Colors.white)),
        ),
      ),
    );
  }
}
