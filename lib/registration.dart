import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../product_overview.dart';
import 'usermodel.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  
  bool isLoading = false;
  final user = FirebaseFirestore.instance.collection('user');
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmpasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sendusers = Provider.of<Products>(context).senduserdetails;
    final firstnameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("first name is required for registration");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter 3 Characters(Min. 3 Character)");
        }
      },
      keyboardType: TextInputType.name,
      onSaved: (value) {
        firstNameEditingController.text = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'First name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final secondnameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        // RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("second name is required for login");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Second name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordEditingController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        firstNameEditingController.text = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final confirmPassword = TextFormField(
      autofocus: false,
      controller: confirmpasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmpasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password Dont match ";
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value.toString();
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'confirm password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    final signupButton = Material(
      elevation: 5,
      color: Colors.red,
      borderRadius: BorderRadius.circular(20),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
                       
            if (_formKey.currentState!.validate()) {
              try {
                 setState(() {
                   isLoading = true;
                 });                
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: emailEditingController.text.trim(),
                        password: passwordEditingController.text.trim())
                    .then((_) => {
                          sendusers(firstNameEditingController.text,
                              emailEditingController.text),
                          Navigator.of(context).pop()
                        });
                    setState(() {
                      isLoading = !isLoading;
                    });
  ;
              } on FirebaseAuthException catch (e) {
                print(e);
              }
            }
          },
          child: Text('Sign up', style:TextStyle(color: Colors.white))),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.red,
            )),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(36),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      firstnameField,
                      SizedBox(height: 20),
                      secondnameField,
                      SizedBox(height: 20),
                      emailField,
                      SizedBox(height: 20),
                      passwordField,
                      SizedBox(height: 20),
                      confirmPassword,
                      SizedBox(height: 20),
                      ((isLoading) ? Container(child: Center(child: CircularProgressIndicator(color: Colors.orange))) : signupButton )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
