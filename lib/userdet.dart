import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDet extends StatefulWidget {
  const UserDet({Key? key}) : super(key: key);

  @override
  State<UserDet> createState() => _UserDetState();
}

class _UserDetState extends State<UserDet> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: users,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('please wait');
          } else if (snapshot.hasError) {
            return Text('Erroxr occured');
          }
          print(snapshot.requireData.docs.length);
          final data = snapshot.requireData.docs
              .firstWhere((element) => element['email'] == currentUser!.email);
          return data['name'];
        });
  }
}
