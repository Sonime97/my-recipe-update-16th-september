import 'dart:ui';


import 'Profile_pic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comments extends StatefulWidget {
  // const Comments({ Key? key }) : super(key: key);
  String str;
  int id;
  Comments({required this.id, required this.str});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  var name;
  var _Images = {};
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    final getnames = Provider.of<Products>(context).getusers();
    
 //   final images = Provider.of<Products>(context).images;
    final filterUser = Provider.of<Products>(context).getspecificuser();
//    final filterimage = Provider.of<Products>(context).getspecificimage();
    final names = Provider.of<Products>(context).users;
    final images = Provider.of<Products>(context).images;
    await getnames;
     Future.delayed(Duration(seconds: 10),() => setState(() {
      _Images = images;
    }));
    
    filterUser;
    print(names);
    name = names[FirebaseAuth.instance.currentUser!.email];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> posts = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.str)
        .collection('comments')
        .snapshots();

    return StreamBuilder(
        stream: posts,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('please wait');
          } else if (snapshot.hasError) {
            return Text('Error occured');
          }
          print(snapshot.requireData.docs.length);
          FirebaseFirestore.instance
              .collection('products')
              .doc(widget.str)
              .update({'commentnumber': snapshot.requireData.docs.length});
          // final username = FirebaseFirestore.instance.collection()
          final data = snapshot.requireData.docs;
          return SizedBox(
            height: 100,
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Row(mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               ProfilePic(data[index]['email']),
                              
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  '${data[index]['name']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                            Container(
                                padding: EdgeInsets.only(left: 54),
                                child: Text(
                                    '${data[index]['date']}',
                                    style: TextStyle(color: Colors.grey))),
                            SizedBox(height: 10),
                            Container(
                                padding: EdgeInsets.only(left: 54),
                                child: Text(data[index]['comment'])),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 34),
                                    child: Text('')),
                                SizedBox(width: 200),
                                Text('')
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10)
                      ]);
                }),
          );
        });
  }
}
//    Column(


//                    children: [
//                      Container(
//                        height: 100,
 //                       child: Card(
 //                       color: Colors.white,
   //                     child: 
     //                   ListTile(
       //                   leading: Text('${data[index]['name']} : ',style: TextStyle(fontWeight: FontWeight.bold),),
     //                     title: Text('${data[index]['comment']}'),
       //                   ),
                     
                          
                           
     //                   ),
    //                  ),
                     
      //              ],
          //        ),