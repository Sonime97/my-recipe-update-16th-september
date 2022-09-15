import 'add_blog_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sonime_app/login.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'blogdetailbackup.dart';
import 'product_overview.dart';
//import '../blog_detail.dart';
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        
        ChangeNotifierProvider.value(
        value: Products(),
       ),
      ],
      //this suppose to be material app
      child: MyApp())
       
    );
}
// i was tring to work on the auth 
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(fontFamily: 'Cairo'),
      routes:  {
    BlogDetail.routeName:(context) => BlogDetail(),
 //   BlogDetailScreen.routeName: (context) =>  BlogDetailScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
  
  }, 
      home: Scaffold(
    body: StreamBuilder<User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }
        
        else if(snapshot.hasError) {
          return Center(child: Text('something went wrong'),);
        }
        else if(snapshot.hasData) {
          return HomeMenu();

        }
        else if(snapshot.connectionState == ConnectionState.active) {
           return LoginScreen();
        }
        else {return Container(child: Center(child: CircularProgressIndicator())); }
        
      }
    )
    ));  
    
  }
}