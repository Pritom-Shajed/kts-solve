
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:house_rent/pages/new_post_form.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PostViewDetails extends StatefulWidget {
String uid ;
DateTime date;
Map<String,dynamic> rentType;
Future<List<Map<String, dynamic>>> imageurl;
PostViewDetails({required this.rentType,required this.imageurl,required this.uid,required this.date});
  @override
  State<PostViewDetails> createState() =>  _PostViewDetailsState();
}
Map<String, dynamic>? userinfo ;
Future getUsersInfo(String uid) async {
    // Query posts collection for the user's posts
    final document = await FirebaseFirestore.instance.collection('AllUsers').doc('$uid').get();
    userinfo = document.data();
    return document;
}
class _PostViewDetailsState extends State<PostViewDetails> {
@override
  void initState() {
    super.initState();
    
    setState(() {
    getUsersInfo(widget.uid);
    });
    
  }

 
void _makePhoneCall() async {
   Uri dialnumber = Uri(scheme: 'tel',path: '0${userinfo!['phone']}');
await launchUrl(dialnumber);
}
  String getFormattedDate() {
  String time = DateFormat('MMMM dd, yyyy').format(widget.date);
  // DateFormat('MMMM dd, yyyy').format(date);
    // Format the selected date to include the month name
    return time;
  }
    
  @override
  Widget build(BuildContext context) {
    setState(() {
      getUsersInfo(widget.uid);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('বিস্তারিত',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
        actions: [
          Icon(Icons.flag_outlined,color: Colors.black54,size: 22),
          Padding(padding: EdgeInsets.only(right: 10)),
          Icon(Icons.workspaces_outline,color: Colors.black54,size: 22),
          Padding(padding: EdgeInsets.only(right: 10)),
          Icon(Icons.favorite,color: Colors.black54,size: 22),
          Padding(padding: EdgeInsets.only(right: 10)),
        ],
        ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
    future: getUsersInfo(widget.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(height: double.infinity,width: double.infinity, child: Center(child: CircularProgressIndicator())); // Show a loading indicator while fetching data.
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return viewPageUi();
      }
    },
  ) ,
    ) ;
  }

  SafeArea viewPageUi() {
    return SafeArea(
    child: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: widget.imageurl
            , builder: (context,snapshot){
              List<Map<String, dynamic>> img = snapshot.data ?? [{'url' : ''}];
              List<String> ImgStringList = [];
          img.forEach((data) {
            ImgStringList.add('${data['url']}');
          });
              return ImageSlider(imageaddress: ImgStringList);
            }
            ),
            
            Container(
              padding: EdgeInsets.fromLTRB(15, 30, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.rentType['houseDetails'],style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                  Padding(padding: EdgeInsets.only(top: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Icon(Icons.map_outlined,size: 13,),
                      SizedBox(width: 5,), 
                      Text(widget.rentType['rentalAddress'],
                      style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w400),)],),
                  ),),
                  Padding(padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: 
                      Row(children: [
                        Icon(Icons.location_city_outlined,size: 14,),
                        SizedBox(width: 5,), 
                        Text(widget.rentType['rentType'],
                        style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],)),
                      
                      Expanded(
                        child: 
                        Row(children: [
                          Icon(Icons.shower_outlined,size: 14,),
                          SizedBox(width: 5,), 
                          Text('${widget.rentType['washroom']} টি ওয়াস রুম',
                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],))
                    ],
                  ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: 
                      Row(children: [
                        Icon(Icons.calendar_month_outlined,size: 14,),
                        SizedBox(width: 5,), 
                        Text(getFormattedDate(),
                        style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],)),
                      
                      Expanded(
                        child: 
                        Row(children: [
                          Icon(Icons.shelves,size: 14,),
                          SizedBox(width: 5,), 
                          Text('${widget.rentType['baranda']} টি বারিন্দা',
                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],))
                    ],
                  ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: 
                      Row(children: [
                        Icon(Icons.bedroom_parent_outlined,size: 14,),
                        SizedBox(width: 5,), 
                        Text('${widget.rentType['bedroom']} টি বেড রুম',
                        style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],)),
                      
                      Expanded(
                        child: 
                        Row(children: [
                          Icon(Icons.stairs_outlined,size: 14,),
                          SizedBox(width: 5,), 
                          Text('${widget.rentType['flatFloor']} তলাতে',
                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],))
                    ],
                  ),
                  ),

                  Padding(padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: 
                      Row(children: [
                        Icon(Icons.diversity_2_outlined,size: 14,),
                        SizedBox(width: 5,), 
                        Text('${widget.rentType['Religion']} ধর্মের',
                        style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],)),
                      
                      Expanded(
                        child: 
                        Row(children: [
                          Icon(Icons.family_restroom_outlined,size: 14,),
                          SizedBox(width: 5,), 
                          Text(widget.rentType['rentPeopleType'][0],
                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],))
                    ],
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text('অন্যান্য চার্জ সমূহ',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: 
                      Row(children: [
                        Icon(Icons.electric_bolt_outlined,size: 14,),
                        SizedBox(width: 5,), 
                        Text(widget.rentType['electricityBill'],
                        style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],)),
                      
                      Expanded(
                        child: 
                        Row(children: [
                          Icon(Icons.water_drop_outlined,size: 14,),
                          SizedBox(width: 5,), 
                          Text(widget.rentType['waterBill'],
                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],))
                    ],
                  ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(child: 
                      Row(children: [
                        Icon(Icons.gas_meter_outlined,size: 14,),
                        SizedBox(width: 5,), 
                        Text(widget.rentType['gasBill'],
                        style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],)),
                      
                      Expanded(
                        child: 
                        Row(children: [
                          Icon(Icons.payment_outlined,size: 14,),
                          SizedBox(width: 5,), 
                          Text(widget.rentType['servicingCost'],
                          style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w400),)],))
                    ],
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 15),
                    child: Text('অন্যান্য সুবিধা সমূহ',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal ,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.elevator_outlined),
                              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                              child:Text('লিফট'), 
                              ),
                              widget.rentType['lift'] ? Text('আছে',style: TextStyle(color: Colors.red)) : Text('নাই',style: TextStyle(color: Colors.red))
                              
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.change_circle_outlined),
                              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                              child:Text('জেনারেটর'), 
                              ),
                              widget.rentType['generator'] ? Text('আছে',style: TextStyle(color: Colors.red)) : Text('নাই',style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.garage_outlined),
                              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                              child:Text('পার্কিং সুবিধা'), 
                              ),
                              widget.rentType['parking'] ? Text('আছে',style: TextStyle(color: Colors.red)) : Text('নাই',style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ) ,
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.security_outlined),
                              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                              child:Text('গার্ড'), 
                              ),
                              widget.rentType['securityGuard'] ? Text('আছে',style: TextStyle(color: Colors.red)) : Text('নাই',style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.gas_meter_outlined),
                              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                              child:Text('গ্যাস সুবিধা'), 
                              ),
                              widget.rentType['gas'] ? Text('আছে',style: TextStyle(color: Colors.red)) : Text('নাই',style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ) , 
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.wifi_tethering_outlined),
                              Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                              child:Text('WIFI সুবিধা'), 
                              ),
                              widget.rentType['wifi'] ? Text('আছে',style: TextStyle(color: Colors.red)) : Text('নাই',style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ) , 
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 15),
                    child: Text('বাসা সম্পর্কে',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                  ),
                  Text(widget.rentType['houseDetails'],style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 15),
                    child: Text('বিজ্ঞাপন দাতা',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                  ),
                  GestureDetector(
                    onTap: _makePhoneCall,
                    child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color:Colors.black12 )
                            ),
                            child: ListTile(leading: CircleAvatar(backgroundColor: Color.fromARGB(8, 0, 0, 0), child: Icon(Icons.person_outlined,size: 30,color: Colors.black26,),) ,title: Text('${userinfo!['name']}') ,subtitle: Text('${userinfo!['phone']}') )
                          ) ?? CircularProgressIndicator(),
                  ),
                Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 15),
                    child: Text('লেনদেন এর সময় সতর্ক থাকুন',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                  ),
                Container(
                  padding: EdgeInsets.all(15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(34, 244, 67, 54),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: Text('কোন ধরনের আর্থিক লেনদেনের সাথে KTS সম্পৃক্ত নয়। যেকোন ধরনের আর্থিক লেনদেন এর ক্ষেত্রে ব্যবহারকারীকে যাচাই বাছাই করে লেনদেন করার অনুরোধ করা হচ্ছে। কেউ কোন ব্যাক্তির মাধ্যমে প্রতারিত হয়ে থাকলে এর দায়ভার KTS কম বহন করবে না।',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),)
                        ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(34, 244, 67, 54),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color:Colors.black12 )
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,size: 16,),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text('বিজ্ঞাপনে কোনো অসামঞ্জস্য তথ্য পেলে এখনই রিপোর্ট করুন',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                              ],
                            ),
                          )
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    )
    );
  }
}

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    super.key,
    required this.imageaddress,
  });

  final List<String> imageaddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CarouselSlider.builder(itemCount: imageaddress.length, 
      itemBuilder: (context,index,realIndex) {
        final imageadd = imageaddress[index];
        return buildImage(imageadd,index);
      },
      options: CarouselOptions(
        height: 250.00
      )),
    );
  }
}

Widget buildImage(String imageadd, int index) {
 return Container(
  child: Image(image: NetworkImage(imageadd,),fit: BoxFit.cover) 
 );
}


