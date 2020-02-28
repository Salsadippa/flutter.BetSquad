import 'package:flutter/material.dart';

const kTextFieldInputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(Icons.mail, color: Colors.orange,),
    hintText: 'Email address',
    hintStyle: TextStyle(
        color: Colors.grey
    )
);