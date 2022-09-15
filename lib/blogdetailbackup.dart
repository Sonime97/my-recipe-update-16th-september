import 'package:firebase_auth/firebase_auth.dart';
import 'comments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'comments.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key}) : super(key: key);
  static const routeName = 'blog-detailScreenbackup';
  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  var image;
  var name;
  final Stream<QuerySnapshot> products =
      FirebaseFirestore.instance.collection('products').snapshots();
  var commentNo = 0;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final getnames = Provider.of<Products>(context).getusers();
    
    final images = Provider.of<Products>(context).images;
    final filterimage = Provider.of<Products>(context).getspecificimage();    

    final filterUser = Provider.of<Products>(context).getspecificuser();
    print(MediaQuery.of(context).size.width);
    
    final names = Provider.of<Products>(context).users;
    getnames;
    filterUser;
    filterimage;
    print(names);
    name = names[FirebaseAuth.instance.currentUser!.email];
    image = images[FirebaseAuth.instance.currentUser!.email];
    final req = Provider.of<Products>(context).allPosts();
    req;
    final allprod = Provider.of<Products>(context).allItems;

    print(allprod);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year.toString();
  final month = DateTime.now().month.toString();
  final day = DateTime.now().day.toString();  
    final ProductId = ModalRoute.of(context)!.settings.arguments;
    final _formKey = GlobalKey<FormState>();
    //final ProductId = ModalRoute.of(context)!.settings.arguments;
    final _commentController = TextEditingController();
    final CommentCountRef =
        FirebaseFirestore.instance.collection('products').doc('${ProductId}');
    final CommentRef = FirebaseFirestore.instance
        .collection('products')
        .doc("${ProductId}")
        .collection('comments');
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.yellow),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: products,
            builder:
                ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('please wait');
              } else if (snapshot.hasError) {
                return Text('Error occured');
              }
              final data = snapshot.requireData.docs
                  .firstWhere((element) => element.id == ProductId);
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            child: Image.network(
                              '${data['image']}',
                              fit: BoxFit.cover,
                            ),
                            //height: 500,
                            height: 400,
                            width: MediaQuery.of(context).size.width),
                      ],
                    ),
                    Positioned(
                      //top: 1.0,
                      //top: 200,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          height: MediaQuery.of(context).size.height/1.5,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text('${data['name']}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                SizedBox(height: 10),
                                Text(
                                  '${data['author']}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 184, 246, 186),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 80,
                                          width:  MediaQuery.of(context).size.width/5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.alarm),
                                              Text('${data['duration']}')
                                            ],
                                          )),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 246, 239, 165),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          // color: Colors.green,
                                          height: 80,
                                          width: MediaQuery.of(context).size.width/5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_box),
                                              Text('${data['complexity']}')
                                            ],
                                          )),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 250, 195, 242),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          // color: Colors.green,
                                          height: 80,
                                          width: MediaQuery.of(context).size.width/5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.thermostat),
                                              Text('${data['Heat']}')
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: SizedBox(
                                    child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text('Ingredients:',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 20),
                                          Column(children: [
                                            Container(
                                                height: 20,
                                                // padding: EdgeInsets.all(20),
                                                child: Text(
                                                    '${data['ingredient']}'))
                                          ]),
                                          SizedBox(height: 20),
                                          Text('Process:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          SizedBox(height: 20),
                                          Text('${data['prep']}'),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Comments(${data['commentnumber']})',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                     
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  padding: EdgeInsets.all(5),
                                                  child: Text('')),
                                            ],
                                          ),
                                          Comments(
                                            id: data['id'],
                                            str: data.id,
                                          )
                                        ])),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            })),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 248, 238, 149),
          onPressed: () {
            // Add your onPressed code here!
          },
          child: IconButton(
            icon: Icon(
              Icons.comment,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  builder: (builder) {
                    return Container(
                        height: 400,
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Form(
                            
                            key: _formKey,
                            child: TextFormField(
                              controller: _commentController,
                              onSaved: (value) {
                                _commentController.text = value.toString();
                              },
                              validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          } else if (value.length < 10) {
                                            return 'Text must be greater than 10';
                                          }
                                          return null;
                                        },
                              decoration: InputDecoration(hintText: 'Enter comment'),
                              minLines:
                                  4, // any number you need (It works as the rows for the textarea)
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                             
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Container(
                            padding: EdgeInsets.all(20),
                            child: GestureDetector(
                              child: Text('Send',style: TextStyle(color: Colors.white)),
                              onTap: () {
                                if (_formKey.currentState!
                                                  .validate()) {
                                                // commentNo++;
                                                // CommentCountRef.add();
                                                
                                                CommentRef.add(
                                                  {
                                                    "name": name,
                                                    'comment':
                                                        _commentController.text,
                                                    'date': '${day}-${month}-${year}',
                                                    'image': '${image}',
                                                    'email': FirebaseAuth.instance.currentUser!.email 
                                                  },
                                                );
                                                // print(ProductId);
                                                // If the form is valid, display a snackbar. In the real world,
                                                // you'd often call a server or save the information in a database.
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Comment Added')),
                                                );
                                                _commentController.clear();
                              }
                  }),
                            decoration: BoxDecoration(color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                            )],)
                        ]));
                  });
            },
          ),
        ));
  }
}
