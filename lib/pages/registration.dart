import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_rent/pages/login.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../api/firebase_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String errorMessage = '';

  void _registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();

    // Perform basic validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields.';
      });
      return;
    }

    // Attempt user registration
    String? registrationError =
        await firebaseService.registerUser(name, email, password,phone);

    if (registrationError == null) {
      // Registration successful, move to group chat screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(),
        ),
      );
    } else {
      // Registration failed, display the error message
      setState(() {
        errorMessage = registrationError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Color.fromARGB(
                  255, 248, 250, 250), // Background color of AppBar
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0), // Rounded bottom corners
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.navigate_before_sharp,size: 30,color: Color.fromARGB(255, 0, 0, 0),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Add logic to handle back navigation if needed
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  "Registration",
                  style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 63, 63, 63)),
                ),
                Spacer(), // Adds flexible space between title and actions
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Container(
                      height: 33.0,
                      width: 243.0,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Khooj The Search",
                              style: GoogleFonts.poppins(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF494949)))),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    Text("House Rental System",
                        style: GoogleFonts.poppins(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF379FAA))),
                    SizedBox(height: 30,),
                    Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30.0,bottom: 15),
                    child: Text("Complete Your Registration",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000))),
                  ),
                Container(
                        height: 75.0,
                        width: 315.0,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle_outlined),
                              labelText: "Enter Your Name",
                              border: OutlineInputBorder()),
                        ),
                      ),
                SizedBox(height: 16),
                Container(
                        height: 75.0,
                        width: 315.0,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.alternate_email_outlined),
                              labelText: "Enter Your Email",
                              border: OutlineInputBorder()),
                        ),
                      ),
            
                SizedBox(height: 16),
                Container(
                        height: 75.0,
                        width: 315.0,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password_outlined),
                              labelText: "Enter Your Password",
                              border: OutlineInputBorder()),
                        ),
                      ),
                SizedBox(height: 16),
                Container(
                        height: 75.0,
                        width: 315.0,
                        child: IntlPhoneField(
                  decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Enter Your Mobile Number"),
                  controller: phoneController,
                ),
                      ),
                SizedBox(height: 40,),
                GestureDetector(
                  onTap:  _registerUser,
                  child: Container(
                      height: 50.0,
                      width: 250.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xFF98EAF3)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("SUBMIT",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF004A54)))),
                    ),
                ),
                SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}