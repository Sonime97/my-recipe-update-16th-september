import 'providers/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:convert';
import 'login.dart';
import '../providers/products.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
//import 'carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  // const ProfilePage({ Key? key }) : super(key: key);
  String username;
  ProfilePage({required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var isLoading = false;
  var id;
  var name;
  var image;
  final email = FirebaseAuth.instance.currentUser!.email;
  
  
 final Users =  FirebaseFirestore.instance.collection('users');
  @override
  

  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final getnames = Provider.of<Products>(context).getusers();
    final filterUser = Provider.of<Products>(context).getspecificuser();
    final filterimage = Provider.of<Products>(context).getspecificimage();
    final filterId = Provider.of<Products>(context).getspecificId();
    final ids = Provider.of<Products>(context).user_Id;
    final names = Provider.of<Products>(context).users;
    final images = Provider.of<Products>(context).images;
    
    getnames;
    filterUser;
    filterId;
    filterimage;
    //names.forEach((key, value) {email = key;});
    setState(() {
    image = images[FirebaseAuth.instance.currentUser!.email];
    name = names[FirebaseAuth.instance.currentUser!.email];
    id = ids[FirebaseAuth.instance.currentUser!.email];  
    });
    
    print(names);
    print(id);
    print(images[FirebaseAuth.instance.currentUser!.email]);
    super.didChangeDependencies();
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  
  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref('files').child(path);
    ref.putFile(file);
    // final snapshot = await uploadTask?.whenComplete(() => {});
    final urlDownload = await ref.getDownloadURL();
    //await snapshot?.ref.getDownloadURL();
    print('Download Link: $urlDownload');
  }
final Stream<QuerySnapshot> userstream =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
     
     final logout = Provider.of<Products>(context).logout;
    final imageRef = FirebaseFirestore.instance.collection('users').doc(id);
    Future Submit () async {
    isLoading = !isLoading;
    final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref('files').child(path);
      ref.putFile(file);
       final snapshot = await uploadTask?.whenComplete(() => {});
     // final month = DateTime.now().month.toString();
     // final day = DateTime.now().day.toString();
    //  final year = DateTime.now().year.toString();
      final urlDownload = await ref.getDownloadURL();
      //await snapshot?.ref.getDownloadURL();
      print('Download Link: $urlDownload');
      //imgList.add(_imageUrlController.text.trim());
      imageRef.update({
       'image': urlDownload}).then((_) {
       // setState(() {
       //   pickedFile = null;
      //  }); 
        // imgList.add(_imageUrlController.text);
       // Navigator.pop(context);
      });

  }
    
    final sk = FirebaseAuth.instance.currentUser;
    final year = FirebaseAuth.instance.currentUser!.metadata.creationTime!.year;
    final month =
        FirebaseAuth.instance.currentUser!.metadata.creationTime!.month;
    final day = FirebaseAuth.instance.currentUser!.metadata.creationTime!.day;
    final hour = FirebaseAuth.instance.currentUser!.metadata.creationTime!.hour;
    final current_Year = DateTime.now().year;
    final current_Month = DateTime.now().month;
    final current_Day = DateTime.now().day;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromARGB(255, 244, 244, 145),
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
        body: StreamBuilder<QuerySnapshot>(
      stream: userstream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final data = snapshot.requireData.docs
        .firstWhere((element) => element['email'] == FirebaseAuth.instance.currentUser!.email);

        return Column(
          children: [
            Container(
                padding: EdgeInsets.all(80),
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ((pickedFile != null)
                        ? CircleAvatar(
                            radius: 100.0,
                            child: ClipOval(
                                      child: SizedBox.fromSize(
                                        size:
                                            Size.fromRadius(78), // Image radius
                                        child: Image.file(
                                      File(pickedFile!.path!),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                      ),
                                    ),
                            backgroundColor: Colors.transparent,
                          )
                        : (data['image'] == 'no')
                            ? CircleAvatar(
                                 backgroundColor: Colors.orange,
                                radius: 90.0,
                                backgroundImage: AssetImage(
                              "assets/images/person-304893_1280.png"),
                             // fit: BoxFit.cover
                        //  backgroundColor: Colors.transparent
                         
                                
                              )
                            : (CircleAvatar(
                                radius: 90.0,
                                backgroundImage: NetworkImage("${data['image']}"),
                                backgroundColor: Colors.orange,
                              ))),
                    Positioned(
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 20,
                          child: IconButton(
                              icon: Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                selectFile();
                              }),
                        ),
                      ),
                    )
                  ],
                )),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70))),
                    child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(30),
                            child: SingleChildScrollView(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '${name}',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                                Divider(
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  thickness: 2,
                                ),
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '${email}',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                                Divider(
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  thickness: 2,
                                ),
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date of Creation',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '${day}-${month}-${year}',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                                Divider(
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  thickness: 2,
                                ),
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '${current_Day.toString()} -''${current_Month.toString()}-''${current_Year.toString()}',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                                Divider(
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ((pickedFile != null)
                                        ? GestureDetector(
                                            child: Container(
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.red),
                                            child: Text('Update',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),onTap: () async {
                                           isLoading = !isLoading;
                                           if(isLoading == true) {
                                            return null;
                                           }
                                           // uploadFile();
                                           
                                           await  Submit();
                                            
                                            setState(() {
                                              pickedFile = null;  
                                            });
                                             
                                          })
                                        : Container( 
                                    )),
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onTap: () {
                                         logout();
                                         Navigator.pop(context);
  
//  Navigator.of(context).removeRouteBelow(ModalRoute.of(context));

                                      },
                                    ),
                                  ],
                                )
                              ],)
                              
                            ))))),
          ],
        );}));
  }
}
