import 'user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logout = Provider.of<Products>(context).logout;
    final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();
    final user = FirebaseAuth.instance.currentUser!.email; 
    return StreamBuilder(
      stream: users,
      builder: (context,AsyncSnapshot<QuerySnapshot>snapshot) { 
      if(snapshot.connectionState == ConnectionState.waiting) {
            return Text('please wait');
          }
          else if(snapshot.hasError) {
            return Text('Error occured');

          }
          final data = snapshot.requireData.docs.firstWhere((element) => element['email'] == user);
          print(data['name']); 
         // data.firstWhere((value)=> print(value['email'] == ));
          return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             SizedBox(
               height: 100,
               child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 243, 235, 152),
                  
                ),
                child: Text('${data['name']}',style: TextStyle(fontSize: 20),),
            ),
             ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
             Navigator.push(
             context,MaterialPageRoute(builder: (context) => ProfilePage(username: data['name'],)),);
                // Update the state of the app
                // ...
                // Then close the drawer
              //  Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logout();
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              
              },
            ),
            
            
          ],
        )); 
      }
      );
  }
}