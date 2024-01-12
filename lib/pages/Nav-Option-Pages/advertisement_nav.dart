import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_rent/pages/new_post_form.dart';
import 'package:house_rent/pages/post_view_details.dart';
import 'package:intl/intl.dart';

class AdvertisementNav extends StatefulWidget {
  const AdvertisementNav({super.key});

  @override
  State<AdvertisementNav> createState() => _AdvertisementNavState();
  
}

 

 
List<dynamic> rentalTypes = [] ;
Future<List<String>> getAllPosts() async {
 int? postno;
    final getpostnumber;
    DocumentSnapshot? documentSnapshot = await FirebaseFirestore.instance
      .collection('postserial')
      .doc('postnumber')
      .get();

 getpostnumber = documentSnapshot.data();
 postno = getpostnumber['postno'];
    final firestore = FirebaseFirestore.instance;

    // Query posts collection for the user's posts
 final querySnapshot = await FirebaseFirestore.instance
      .collection('posts')
      .get()
      .then((snapshots) {
    rentalTypes = [];
   snapshots.docs.forEach((element) {
      // print(element.data());
     rentalTypes.add(element.data());
    });
  });
  return [""];
}



class _AdvertisementNavState extends State<AdvertisementNav> {
List<Map<String, dynamic>> _imageUrls = [];
 @override
  void initState() {
    super.initState();
    
    setState(() {
      _imageUrls = [];
      getAllPosts();
    });
    
  }

Future<List<Map<String, dynamic>>> getImagesFromStorage(int index) async {
  List<Map<String, dynamic>> imageList = [];

  // Initialize Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  try {
    // Replace 'your_folder_path' with the actual path to your images in Firebase Storage
    final ListResult result = await storage.ref('posts').child('post$index').listAll();
    for (final Reference reference in result.items) {
      final String imageUrl = await reference.getDownloadURL();

      // Create a Map for each image and add it to the list
      Map<String, dynamic> imageMap = {
        'url': imageUrl,
      };
      _imageUrls.add(imageMap);
      imageList.add(imageMap);
    }

 
    return imageList;
  } catch (e) {
    // Handle errors here
    print('Error fetching images: $e');
    return [];
  }
}
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      getAllPosts();
    });
    return 
    Scaffold(
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
                  icon: Icon(Icons.meeting_room_sharp,size: 30,color: Color.fromARGB(255, 250, 70, 70),),
                  onPressed: () {
                    // Add logic to handle back navigation if needed
                  },
                ),
                SizedBox(width: 8.0),
                Text(
                   "সকল বিজ্ঞাপন",
                  style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 250, 70, 70)),
                ),
                Spacer(), // Adds flexible space between title and actions
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.0),
      //   child: SafeArea(
      //     child: Container(
      //       padding: EdgeInsets.all(8.0),
      //       decoration: BoxDecoration(
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey.withOpacity(0.5),
      //             spreadRadius: 5,
      //             blurRadius: 7,
      //             offset: Offset(0, 3), // changes position of shadow
      //           ),
      //         ],
      //         color: Color.fromARGB(
      //             255, 248, 250, 250), // Background color of AppBar
      //         borderRadius: BorderRadius.vertical(
      //           bottom: Radius.circular(20.0), // Rounded bottom corners
      //         ),
      //       ),
      //       child: Row(
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.meeting_room_sharp,size: 30,color: Color.fromARGB(255, 250, 70, 70),),
      //             onPressed: () {
      //               // Add logic to handle back navigation if needed
      //             },
      //           ),
      //           SizedBox(width: 8.0),
      //           Text(
      //             "সকল বিজ্ঞাপন",
      //             style: GoogleFonts.openSans(
      //                 fontSize: 22,
      //                 fontWeight: FontWeight.bold,
      //                 color: Color.fromARGB(255, 250, 70, 70)),
      //           ),
      //           Spacer(), // Adds flexible space between title and actions
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body:FutureBuilder<List<Map<String, dynamic>>>(
    future: getImagesFromStorage(0),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(height: double.infinity,width: double.infinity, child: Center(child: CircularProgressIndicator())); // Show a loading indicator while fetching data.
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('No data available');
      } else {
        return buildPageView();
      }
    },
  ) ,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to your desired page when the button is pressed
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateRentPostScreen()));
        },
        label: Text('ফ্রি পোস্ট করুন'),
        icon: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 252, 252, 252), // Customize the button color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Adjust button location
    );

  }

  SafeArea buildPageView() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child:  RefreshIndicator(
          onRefresh: ()async{},
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // FilterBar(),
              //           Container(
              //             height: 400,
              //             width: double.infinity,
              //             child: ListView.builder(
              //   itemCount: _imageUrls.length,
              //   itemBuilder: (context, index) {
              //     final imageUrl = _imageUrls[index][1];

              //     return ListTile(
              //       title: Image.network(imageUrl),
              //     );
              //   },
              // )
              //           ),
                // Container(
                //   height: 50,
                //   child: ListView.builder(itemBuilder: (context,index){
                //     return Text("data");
                //   }),
                // ),
              //             StreamBuilder(
              //               stream: messagesStream,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) return const Text('Loading...');
              //     return ListView.builder(
              //       itemExtent: 225.0,
              //       itemCount: snapshot.data.documents.length,
              //       itemBuilder: (context, index) =>
              //           _buildListItems(context, snapshot.data.documents[index]),
              //     );
              //   },
              // ),
                Container(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: rentalTypes.length,
                    itemBuilder: (BuildContext context,index){
                      Future<List<Map<String, dynamic>>> imageUrls =  getImagesFromStorage(index);
                      String details = rentalTypes[index]['houseDetails'];
                      String rent = rentalTypes[index]['rent'];
                      String Uid = rentalTypes[index]['UID'];
                      String areaname = rentalTypes[index]['rentalArea'];
                      Timestamp getdate = rentalTypes[index]['rentDate'];
                      String renttype = rentalTypes[index]['rentType'];
                      String address = rentalTypes[index]['rentalAddress'];
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(getdate.seconds * 1000);
                      return GestureDetector(onTap:() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostViewDetails(rentType: rentalTypes[index],imageurl: imageUrls,uid : Uid,date :dateTime )));
                      },
                      child: PostItem(imageurls: imageUrls, description: details, price: rent,date: dateTime,rentType:renttype,Address:address,RentalArea:areaname));
                    }
                    ),
                ),
                SizedBox(height: 60,)
                // PostItem(image: AssetImage("assets/images/bedroom.jpg"),description: "ফ্ল্যাট ভাড়া হবে সেপ্টেম্বর মাস থেকে, মিরপুর ১০, 597 est kazipara mirpur Dhaka 1216, 597 est kazipara mirpur Dhaka 1216",price: "৳ ১৫,৭৮৫৭০",),
                // PostItem(image: AssetImage("assets/images/bedroom2.jpg"),description:"বাসা ভাড়া খুঁজছি, ইসলামপুর" ,price: "৳ ৫,০০০",),
                // PostItem(image: AssetImage("assets/images/bedroom3.jpg"),description:"ফ্ল্যাট ভাড়া হবে সেপ্টেম্বর মাস থেকে সাভার" ,price: "৳ ১৫,৭৮৫৭০",),
                // ElevatedButton(onPressed: (){
                //   print(rentalTypes);
                // }, child: Text("data"))
                ],
            ),
          ),
        ),
      ) 
    );
  }
}

class PostItem extends StatelessWidget {
  final DateTime date;
  final String description;
  final String price;
  final String rentType;
  final String Address;
  final String RentalArea;
  final Future<List<Map<String, dynamic>>> imageurls;
  const PostItem({
   required this.description,
   required this.price,
   required this.imageurls,
   required this.date,
   required this.rentType,
   required this.Address,
   required this.RentalArea
  });
String getFormattedDate() {
  String monthName = DateFormat('MMMM').format(date);
  // DateFormat('MMMM dd, yyyy').format(date);
    // Format the selected date to include the month name
    return monthName;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0,15.0 ,20.0,0),
      child: Column(
        children: [
          FutureBuilder(future: imageurls, 
          builder: (context,snapshot){
           final img =snapshot.data ?? [{'url' : ''}];
            return 
          Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.fill, image: NetworkImage( img[0]['url'] )),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),gradient: LinearGradient(begin: Alignment.bottomCenter,end:Alignment.topCenter, colors: [Colors.black87,Colors.transparent])),
              child: Row(
                children: [
                  Icon(Icons.apartment_outlined,color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text(rentType,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                  SizedBox(width: 10.0,),
                  Icon(Icons.calendar_month_outlined,color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text(getFormattedDate(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                  SizedBox(width: 10.0,),
                  Icon(Icons.visibility_outlined,color: Colors.white,),
                  SizedBox(width: 5.0,),
                  Text("0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
            
                ],
              ),
            ),
          );}
          ),
        SizedBox(height: 20.0,),
        Align(alignment: Alignment.centerLeft, child: Text('$description ,$Address ,$RentalArea',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500,height: 1.5),)),
        SizedBox(height: 5.0,),
        Align(alignment: Alignment.centerLeft, child: Text("৳ $price",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }
}


// class FilterBar extends StatelessWidget {
//   const FilterBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.sort),
//                   SizedBox(width: 15.0,),
//                   Text("সর্টিং")
//                 ],
//               ),
//           )),
//           Expanded(
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.black12))),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.location_on_outlined),
//                   SizedBox(width: 15.0,),
//                   Text("সর্টিং")
//                 ],
//               ),
//           )),
//           Expanded(
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.filter_alt_outlined),
//                   SizedBox(width: 15.0,),
//                   Text("সর্টিং")
//                 ],
//               ),
//           )),
//         ],
//       ),
//     );
//   }
// }


