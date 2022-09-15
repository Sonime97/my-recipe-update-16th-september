import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ProfilePic extends StatelessWidget {
  //const ProfilePic({ Key? key }) : super(key: key);
  var email;
   ProfilePic(this.email);
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
        return ((data['image'] == null || data['image'] == "no" )
                                ? CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.orange,
                                    backgroundImage: 
                                         AssetImage(
                                            "assets/images/person-304893_1280.png"),
                                       // fit: BoxFit.contain
                                        //  backgroundColor: Colors.transparent
                                        )
                                : CircleAvatar(
                                    radius: 20.0,
                                     // Image radius
                                        backgroundImage: NetworkImage('${data['image']}',
                                            ),
                                      
                                    
                                    backgroundColor: Colors.orange,
                                  ));
  });}
}