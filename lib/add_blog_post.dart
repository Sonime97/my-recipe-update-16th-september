import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/products.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
//import 'carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:sonime_app/providers/products.dart';

class AddBlogBackup extends StatefulWidget {
  // const AddBlog({ Key? key }) : super(key: key);

  // static const routeName = 'add-Blog';

  @override
  State<AddBlogBackup> createState() => _AddBlogBackupState();
}

class _AddBlogBackupState extends State<AddBlogBackup> {
  var name;
 bool isLoading = false;
  // final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('users').snapshots();
  @override
  void didChangeDependencies() {
    final getnames = Provider.of<Products>(context).getusers();
    final filterUser = Provider.of<Products>(context).getspecificuser();
    final names = Provider.of<Products>(context).users;
    getnames;
    filterUser;
    print(names);
    name = names[FirebaseAuth.instance.currentUser!.email];
    
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  final user = FirebaseAuth.instance.currentUser!.email;
  

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
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

  Future submit() async {
    if (_form.currentState!.validate() && pickedFile != null) {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref('files').child(path);
      ref.putFile(file);
      // final snapshot = await uploadTask?.whenComplete(() => {});
      final month = DateTime.now().month.toString();
      final day = DateTime.now().day.toString();
      final year = DateTime.now().year.toString();
      final urlDownload = await ref.getDownloadURL();
      //await snapshot?.ref.getDownloadURL();
      print('Download Link: $urlDownload');
      //imgList.add(_imageUrlController.text.trim());
      Posts.add({
        'author': name,
        'Heat': Heat,
        'ingredient': _ingredController.text.trim(),
        'complexity': Complexity,
        'duration': Duration,
        'name': _titleController.text.trim(),
        'id': DateTime.now().millisecond,
        'prep': _prepController.text,
        'image': urlDownload, //_imageUrlController.text.trim(),
        'commentnumber': 0,
        'fav': false,
        'date': '${day}-${month}-${year}'
      }).then((_) {
        // imgList.add(_imageUrlController.text);
        setState(() {
          pickedFile = null;
        });
        Navigator.pop(context);
      });
      //imgList.add(_imageUrlController.text);
    } else if (pickedFile == null) {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: const Text('No Image Found'),
                  content: const Text('Please enter an Image'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'okay'),
                      child: const Text('Cancel'),
                    ),
                  ]));
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }
  @override
  void dispose() {
    _ingredController.dispose();
    _titleController.dispose();
    _prepController.dispose();
    
    // TODO: implement dispose
    super.dispose();
  }
  final Posts = FirebaseFirestore.instance.collection('products');
  final _ingredController = TextEditingController();
  final _titleController = TextEditingController();
  final _prepController = TextEditingController();
  final selectImage = false;
  String Complexity = 'Easy';
  String Duration = '0 mins';
  String Heat = '0°C';
  
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    
    final Stream<QuerySnapshot> users =
        FirebaseFirestore.instance.collection('users').snapshots();
    // final name = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
       // backgroundColor: Color.fromARGB(255, 247, 238, 151),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.yellow),
        elevation: 0,
        backgroundColor: Colors.transparent,),
        body: Padding(
          padding: EdgeInsets.all(25),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text('Create A blog',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)))),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                      key: _form,
                      child: ListView(padding: EdgeInsets.all(0), children: [
                        Column(
                          children: [
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Recipe Name'),
                              textInputAction: TextInputAction.next,
                              controller: _titleController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a value';
                                } else if (value.length >= 25) {
                                  return 'Please the length of title should not be over 30 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _titleController.text = value!;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Ingredient'),
                              textInputAction: TextInputAction.next,
                              controller: _ingredController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a value';
                                } 
                                return null;
                              },
                              onSaved: (value) {
                                _ingredController.text = value!;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Process'),
                              textInputAction: TextInputAction.next,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              controller: _prepController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a value';
                                } else if (value.length < 25) {
                                  return 'Please the length should be more than 30 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _prepController.text = value!;
                              },
                            ),
                            Row(
                              children: [
                                Text('Complexity: '),
                                DropdownButton<String>(
                                  value: Complexity,
                                  icon: const Icon(Icons.verified),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.red,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Complexity = newValue!;
                                    });
                                  },
                                  items: <String>['Easy', 'Medium', 'Hard']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(width: 10),
                                Text('Duration: '),
                                DropdownButton<String>(
                                  value: Duration,
                                  icon: const Icon(Icons.alarm),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.red,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Duration = newValue!;
                                    });
                                  },
                                  items: <String>['0 mins', '2-5mins', '>30mins', '>1 hour']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(width: 20),
                                
                              ],
                            ),
                            Row(children: [
                              Text('Heat: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                DropdownButton<String>(
                                  value: Heat,
                                  icon: const Icon(Icons.thermostat),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.red,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      Heat = newValue!;
                                    });
                                  },
                                  items: <String>['0°C', '30°C', '100°C', '>100°C']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )
                            ]),
                            SizedBox(height: 10),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Stack(children: [
                    Container(
                      child: pickedFile != null ? Card(shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                     borderRadius: BorderRadius.circular(10),
                                    // color: Colors.blue[100],
                                    child: Image.file(
                                      File(pickedFile!.path!),
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    )
                                    )): Center(child: Text('No Image Selected')),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      height: 200,
                      width: 300,
                    ),
                    ((pickedFile != null) ? Container() : GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20)),
                        height: 200,
                        width: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      onTap: () async {
                      
                       await selectFile();
                      
                      },
                    ))
                    
                  ])),
                          ],
                        ),
                      ])),
                ),
              ),
              
                  SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ((isLoading) ? Container(child: Center(child: CircularProgressIndicator(color: Colors.orange))) :  
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text('Posts Blog',style: TextStyle(color: Colors.white),), ),
                onTap: () async {
                   setState(() {
                        isLoading = true; 
                       });
                  FocusManager.instance.primaryFocus?.unfocus();
                  await submit();
                  setState(() {
                        isLoading = !isLoading;
                      });
                  Navigator.pop(context);
                },) )
               
              ])
            ]),
          ),
        ));
  }
}
