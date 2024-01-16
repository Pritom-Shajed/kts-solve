import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:house_rent/pages/login.dart';
import 'package:house_rent/pages/new_post_form.dart';
import 'package:house_rent/pages/own_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountNav extends StatefulWidget {
  const AccountNav({super.key});

  @override
  State<AccountNav> createState() => _AccountNavState();
}
Map<String, dynamic> userinfo = {} ;
Map<String, dynamic> nullinfo = {} ;
Future getUsersInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    // Query posts collection for the user's posts
    final document = await FirebaseFirestore.instance.collection('AllUsers').doc('$uid').get();

    userinfo = document.data() ?? nullinfo;
    return document;
}
class _AccountNavState extends State<AccountNav> {
  @override
  void initState() {
    super.initState();
    
    setState(() {
    getUsersInfo();
    });
    
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      getUsersInfo();
    });
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child:  SingleChildScrollView(
          child: Column(
            children: [
FutureBuilder(
    future: getUsersInfo(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(child: Center(child: Column(
          children: [
            SizedBox(height: 50,),
            CircularProgressIndicator(),
            SizedBox(height: 50,),
          ],
        ))); // Show a loading indicator while fetching data.
      } else if (snapshot.hasError) {
        return Container(child: Center(child: Column(
          children: [
            SizedBox(height: 50,),
            CircularProgressIndicator(),
            SizedBox(height: 50,),
          ],
        ))); 
      } else {
        return ProfileSection();
      }
    },
  ) 
              ,
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(alignment: Alignment.centerLeft, child: Text("অ্যাকাউন্ট",style: TextStyle(fontSize: 14.0,fontWeight:FontWeight.w600,color: Colors.black54 ),)),
                    ),
                    SizedBox(height: 15.0,),
                    ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: ((context) => OwnFeedPage()))),
                      leading: Icon(Icons.content_copy_outlined,color: Colors.black,),
                      title: Text("আমার বিজ্ঞাপন সমূহ",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                    GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        insetPadding: EdgeInsets.all(5.0),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Text(
                                                'Profile',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Text(
                                                "Your Name : ${userinfo['name']}",
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,wordSpacing: 2),
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0, bottom: 20.0),
                                              child: Text(
                                                  'Contact - +880${userinfo['phone']}',
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  bottom: 40.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(255, 74, 123, 248),
                                                      Color.fromARGB(255, 22, 71, 206),
                                                    ],
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () {

                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Text(
                                                      'Thank You',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ));
                            },
                            child: ListTile(
                      // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: ((context) => CreateRentPostScreen()))),
                      leading: Icon(Icons.person_outlined,color: Colors.black,),
                      title: Text("আমার প্রোফাইল",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                          ),
                    
                    // ListTile(
                    //   leading: Icon(Icons.lock_outline,color: Colors.black,),
                    //   title: Text("পাসওয়ার্ড পরিবর্তন",style: TextStyle(fontWeight: FontWeight.w500),),
                    // ),
                    SizedBox(height: 20.0,)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(alignment: Alignment.centerLeft, child: Text("অন্যান্য",style: TextStyle(fontSize: 14.0,fontWeight:FontWeight.w600,color: Colors.black54 ),)),
                    ),
                    SizedBox(height: 15.0,),
                    GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        insetPadding: EdgeInsets.all(5.0),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Text(
                                                'About Us',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Text(
                                                  'House Rent Application',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0, bottom: 20.0),
                                              child: Text(
                                                  'Contact - houserent@gmail.com',
                                                  style: TextStyle(fontWeight: FontWeight.normal),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  bottom: 40.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 74, 123, 248),
                                                      Color.fromARGB(
                                                          255, 22, 71, 206),
                                                    ],
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () async{
                                                    final Email email = Email(
                                                      subject: 'Customer Feedback',
                                                      recipients: ['sirahin@gmail.com'],
                                                      isHTML: false,
                                                    );
                                                    await FlutterEmailSender.send(email);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text(
                                                      'Send Email',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ));
                            },
                            child: ListTile(
                      leading: Icon(Icons.info_outline,color: Colors.black,),
                      title: Text("আমাদের সম্পর্কে",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                          ),
                    
                    // ListTile(
                    //   leading: Icon(Icons.pest_control_outlined,color: Colors.black,),
                    //   title: Text("সমস্যা সাবমিট করুন",style: TextStyle(fontWeight: FontWeight.w500),),
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.chat_outlined,color: Colors.black,),
                    //   title: Text("ফিডব্যাক দিন",style: TextStyle(fontWeight: FontWeight.w500),),
                    // ),
                    // ListTile(
                    //   leading: Icon(Icons.turn_right_outlined,color: Colors.black,),
                    //   title: Text("অ্যাপ শেয়ার করুন",style: TextStyle(fontWeight: FontWeight.w500),),
                    // ),
                    GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        insetPadding: EdgeInsets.all(5.0),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Text(
                                                'About Us',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Text(
                                                  "Your privacy is our priority. We respect your right to a secure and private living space. Rest assured that any personal information you provide during the house rental process will be handled with the utmost confidentiality and used solely for the purpose of facilitating your tenancy. Your trust is important to us.",
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,wordSpacing: 2),
                                                  ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       top: 20.0, bottom: 20.0),
                                            //   child: Text(
                                            //       'Contact - houserent@gmail.com',
                                            //       style: TextStyle(fontWeight: FontWeight.normal),
                                            //       textAlign: TextAlign.center),
                                            // ),
                                          ],
                                        ),
                                        actions: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  bottom: 40.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 74, 123, 248),
                                                      Color.fromARGB(
                                                          255, 22, 71, 206),
                                                    ],
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text(
                                                      'Thank You',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ));
                            },
                            child: ListTile(
                      leading: Icon(Icons.description_outlined,color: Colors.black,),
                      title: Text("Privacy Policy",style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                          ),
                    
                    
                    ListTile(
                      leading: Icon(Icons.exit_to_app_outlined,color: Colors.black,),
                      title: Text("লগ আউট",style: TextStyle(fontWeight: FontWeight.w500),),
                      onTap: () async{

    await FirebaseAuth.instance.signOut();
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        await preferences.clear();
                        // After logout, navigate back to LoginScreen
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    )
                  ],
                ),
              )
              ],
          ),
        ),
      ),
    ) ;
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.0,),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(height: 100,width: 100.0,fit: BoxFit.cover, image: AssetImage("assets/images/profile.jpg")),
          ),
          SizedBox(height: 15.0,),
          Text(userinfo['name']  ,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),) ,
          SizedBox(height: 5.0,),
          Text('0${userinfo['phone']}' ,style: TextStyle(color: Colors.black54,fontSize: 16.0,fontWeight: FontWeight.w500),),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}                                                   