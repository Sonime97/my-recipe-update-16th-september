import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserName extends StatelessWidget {
  //const ProfilePic({ Key? key }) : super(key: key);
  var email;
   UserName(this.email);
  @override
  Widget build(BuildContext context) {
     final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final data = snapshot.requireData.docs
                  .firstWhere((element) => element['email'] == email);
        return Text(' ${data['name']}!',style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25));
  });}
}