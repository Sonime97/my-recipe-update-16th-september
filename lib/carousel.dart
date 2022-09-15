import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ComplicatedImageDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final Stream<QuerySnapshot> post = FirebaseFirestore.instance.collection('products').snapshots(); 
    return StreamBuilder(
    stream: post,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting) {
            return Text('please wait');
          }
          else if(snapshot.hasError) {
            return Text('Error occured');
          }
          final data = snapshot.requireData;
          final List<Widget> imageSliders = data.docs
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item['image'], fit: BoxFit.cover, width: 280.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 20.0),
                        child: Text('${item['name']}',style: TextStyle(color: Colors.white,fontSize: 20)) 
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
          return Container(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.8,
            enlargeCenterPage: true,
          ),
          items: imageSliders,
        ),
      );
    }); 
    
    
    
  }
}