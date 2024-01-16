import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_rent/pages/Nav-Option-Pages/account_nav.dart';
import 'package:house_rent/pages/Nav-Option-Pages/advertisement_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}
Map<String, dynamic> userinfo = {} ;
Map<String, dynamic> nullinfo = {} ;
List<Map<String, dynamic>> newPosts = [];

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future getUsersInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    // Query posts collection for the user's posts
    final document = await FirebaseFirestore.instance.collection('AllUsers').doc('$uid').get();

    userinfo = document.data() ?? nullinfo;
    return document;
}
class _HomeNavState extends State<HomeNav> {
  @override
  void initState() {
    super.initState();
    fetchAllPosts();
    setState(() {
    getUsersInfo();
    });
    
  }

  Future<void> fetchAllPosts() async {
    newPosts = [];
    try {
      // Get the total number of posts from Firestore
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection('posts').get();

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          querySnapshot.docs;

      documents.forEach((e) {
        setState(() {
          newPosts.add(e.data());
        });
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getUsersInfo();
    });
    return Scaffold(
   appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 6), // changes position of shadow
                ),
              ],
              color: Color.fromARGB(
                  255, 248, 250, 250), // Background color of AppBar
              borderRadius: BorderRadius.all(
                Radius.circular(20.0), // Rounded bottom corners
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.meeting_room_sharp,size: 30,color: Color.fromARGB(255, 250, 70, 70),),
                  onPressed: () {
                    // Add logic to handle back navigation if needed
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                  "Khooj The Search",
                  style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 250, 70, 70)),
                ),
                Spacer(), // Adds flexible space between title and actions
                // GestureDetector(onTap: (){ }, child: CircleAvatar(child: Icon(Icons.person_2_outlined),))
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async{
          fetchAllPosts();
          setState(() {
            getUsersInfo();
          });
        },
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child:  SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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
          return Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 20),
                  child: Align(alignment: Alignment.centerLeft, child: Text('Hello, ${userinfo['name']}',style:GoogleFonts.openSans(fontSize: 16,fontWeight: FontWeight.bold))),
                );
        }
            },
          ) ,
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 10,bottom:25 ),
                  child: Align(alignment: Alignment.centerLeft, child: Text('Search Your Next Home for better living with a peaceful Sociaty',style:GoogleFonts.openSans(fontSize: 13,fontWeight: FontWeight.w400))),
                ),
                NoticeMsg(),
                SizedBox(height: 20.0),


                 GestureDetector(
                  onTap:(){
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=> AdvertisementNav() ));},

                  child: NewPosts()),
                PopularCatagories(),
                ],
            ),
          ),
        ),
      ),
    ),
    ); 
  }
}

class NewPosts extends StatelessWidget {
  const NewPosts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
      Padding(
        padding: EdgeInsets.only(left:15.0),
        child: Align(alignment: Alignment.centerLeft, child: Text("নতুন পোস্ট সমূহ",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),)),
      ),
      SizedBox(height: 20.0,),
        newPosts.isEmpty ? Text('No new posts found!') : SizedBox(
        height: 150,
        child: ListView.builder(
          shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: newPosts.length,
            itemBuilder: (context, index){
          return Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/images/house_search.svg', width: 50, height: 50,),
                ),
                SizedBox(height: 10.0,),
                Text(newPosts[index]['rentType'],style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                Text('${newPosts[index]['rent']} BDT')
              ],
            ),
          );
        }),
      ),

    ],
    );
  }
}

class PopularCatagories extends StatelessWidget {
  const PopularCatagories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.0,top: 20.0,bottom: 20.0),
      color: Color.fromARGB(255, 255, 253, 253),
      child: Column(
        children: [
          Align(alignment: Alignment.centerLeft, child: Text("জনপ্রিয় ক্যাটাগরি",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),)),
        SizedBox(height: 10.0,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                height: 55.0,
                width: 130.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_2),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ব্যাচেলর",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                        Text("৩৫ টি",style: TextStyle(fontSize: 10.0,color: Colors.black87,fontWeight: FontWeight.w500),)
                      ],
                    )
                  ],
                )
              ),
              SizedBox(width: 10.0,),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 55.0,
                width: 130.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Row(
                  children: [
                    Icon(Icons.family_restroom),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ফ্যামিলি",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                        Text("৫৮ টি",style: TextStyle(fontSize: 10.0,color: Colors.black87,fontWeight: FontWeight.w500),)
                      ],
                    )
                  ],
                )
              ),
              SizedBox(width: 10.0,),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 55.0,
                width: 130.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Row(
                  children: [
                    Icon(Icons.family_restroom_rounded),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ফ্যামিলি",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                        Text("৩৫ টি",style: TextStyle(fontSize: 10.0,color: Colors.black87,fontWeight: FontWeight.w500),)
                      ],
                    )
                  ],
                )
              )
            ],
          ),
        )
        ,SizedBox(height: 10.0,)
        ,SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                height: 55.0,
                width: 130.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_2),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("শুধুমাত্র ছাত্রী",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                        Text("৯ টি",style: TextStyle(fontSize: 10.0,color: Colors.black87,fontWeight: FontWeight.w500),)
                      ],
                    )
                  ],
                )
              ),
              SizedBox(width: 10.0,),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 55.0,
                width: 130.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Row(
                  children: [
                    Icon(Icons.family_restroom),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("শুধুমাত্র পুরুষ",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                        Text("৭ টি",style: TextStyle(fontSize: 10.0,color: Colors.black87,fontWeight: FontWeight.w500),)
                      ],
                    )
                  ],
                )
              ),
              SizedBox(width: 10.0,),
              Container(
                padding: EdgeInsets.all(10.0),
                height: 55.0,
                width: 130.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Row(
                  children: [
                    Icon(Icons.family_restroom_rounded),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("শুধুমাত্র ছাত্র",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w600),),
                        Text("৭ টি",style: TextStyle(fontSize: 10.0,color: Colors.black87,fontWeight: FontWeight.w500),)
                      ],
                    )
                  ],
                )
              )
            ],
          ),
        )
        ,SizedBox(height: 10.0,)

        ],
      ),
    );
  }
}



class NoticeMsg extends StatelessWidget {
  const NoticeMsg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 88.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 237, 237),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.black12),
          image: DecorationImage(image: AssetImage("assets/images/findhouse.png"),alignment: Alignment.centerRight,fit: BoxFit.fitHeight)
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("পছন্দের পরিবেশে বাড়ি খুজুন",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
              SizedBox(height: 5.0,),
              Text("আপনি যেই এলাকাতে বাসা ভাড়া \nনিতে ইচ্ছুক",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}