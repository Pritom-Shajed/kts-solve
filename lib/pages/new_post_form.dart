
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_rent/mock/create/rental_type.dart';
import 'package:house_rent/pages/Landing/landing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRentPostScreen extends StatefulWidget {
  @override
  _CreateRentPostScreenState createState() => _CreateRentPostScreenState();
}
 int _currentStep = 0;
 int? currentpost ;
class _CreateRentPostScreenState extends State<CreateRentPostScreen> {
 
  bool ? value;
 


  final List<String> applicableForOptions = ['Bachelor', 'Family', 'Girls Student', 'Boys Student'];
  final List<int> bedroomCounts = [1, 2, 3];
// void toggleSportSelection(String renttype){
//   setState(() {
//     if(_selectedApplicableFor.contains(renttype)){
//       _selectedApplicableFor.remove(renttype);
//     } else {
//       _selectedApplicableFor.add(renttype);
//     }
//   });
// }
List<Step> _steps = [
    Step(title: Text('ভাড়ার ধরন',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.red)), content: Step1Form()),
    Step(title: Text('ভাড়ার বিবরণ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.red)), content: Step2Form()),
    Step(title: Text('বাসার ছবি আপলোড করুন *',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.red)), content: Step3Form()),
  ];

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Rent Post')),
      body: SingleChildScrollView(
        child: 
        Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 25,left: 25),
            //   child: Align(alignment: Alignment.topLeft, child: Text("ভাড়ার ধরন",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.red),)),
            // ),
            Stepper(

              physics: ScrollPhysics(),
              type: StepperType.vertical,
              currentStep: _currentStep,
              steps: _steps,
              onStepContinue: () {
                setState(() {
            if (_currentStep < _steps.length - 1) {
              _currentStep += 1;
              
            }
          });
              },
              onStepCancel: () {
                setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            }
          });
              },
            ),
          ],
        ),
      ),
    );
  }



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Create Rent Post'),backgroundColor: Colors.red,),
  //     body: Column(
  //       children: [
  //         SizedBox(
  //           height: 80,
  //           child: ListView.builder(
  //           itemCount: rentTypes.length, 
  //           scrollDirection: Axis.horizontal,
  //           itemBuilder: (context, index){
  //             final renttype= rentTypes[index];
  //             return Padding(padding: EdgeInsets.all(8),
  //             child: ChoiceChip(
  //               label: Text(renttype),
  //               selectedColor: Colors.red,
  //               selected: _selectedApplicableFor.contains(renttype),
  //               onSelected: (bool Selected)
  //               {setState(() {
  //                       if(_selectedApplicableFor.contains(renttype)){
  //     _selectedApplicableFor.remove(renttype);
  //   } else {
  //     _selectedApplicableFor.add(renttype);
  //   }
  //                     });
  //                   },
                
  //               ),
  //             );
  //           }),
  //         )
  //       ],
  //     )
  //   );
  }


class Step1Form extends StatefulWidget {
  const Step1Form({super.key});

  @override
  State<Step1Form> createState() => _Step1FormState();
}

  final List<String> rentTypes = ['ফ্ল্যাট ভাড়া', 'সিট ভাড়া', 'সাবলেট ভাড়া'];
  String _selectedrentType = "";
  int? choiceIndex ;
  int _bedno=0;
  int _washno=0;
  int _barandano=0;
  int _flatno=0;

  List<String> _selectedApplicableFor = [];
  final List<String> applicableForOptions = ['ব্যাচেলর', 'ফ্যামিলি', 'ছোট ফ্যামিলি', 'শুধুমাত্র ছাত্র', 'শুধুমাত্র ছাত্রী', 'শুধুমাত্র পুরুষ', 'শুধুমাত্র মহিলা', 'পুরুষ চাকরিজীবী', 'মহিলা চাকরিজীবী'];
class _Step1FormState extends State<Step1Form> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Align(alignment: Alignment.topLeft, child: Text("আপনি কি ভাড়া দিতে চান *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
          SizedBox(
            height: 80,
            child: ListView.builder(
            itemCount: rentTypes.length, 
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              final renttype= rentTypes[index];
              return Padding(padding: EdgeInsets.all(8),
              child: ChoiceChip(
                label: Text(renttype),
                selectedColor: Colors.green.shade300,
                selected: choiceIndex == index,
                onSelected: (bool Selected)
                { setState(() {
                   choiceIndex = Selected ? index : 0;
                   _selectedrentType = renttype;
                });
                 
                    },
                
                ),
              );
            }),
          ),
          Align(alignment: Alignment.topLeft, child: Text("আপনি কাদের কাছে ভাড়া দিতে চান? *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
          SizedBox(
            height: 160,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: 130,crossAxisCount: 3),
            itemCount: applicableForOptions.length, 
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              final renttype= applicableForOptions[index];
              return ChoiceChip(
                showCheckmark: true,
                label: Text(renttype),
                selectedColor: Colors.green.shade300,
                selected: _selectedApplicableFor.contains(renttype),
                onSelected: (bool Selected)
                {setState(() {
                        if(_selectedApplicableFor.contains(renttype)){
      _selectedApplicableFor.remove(renttype);
    } else {
      _selectedApplicableFor.add(renttype);
    }
                      });
                    },
                
                );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Align(alignment: Alignment.topLeft, child: Text("বেড রুম *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
               NumberStepper(initialValue: _bedno, min: 0, max: 5, step:1, onChanged: (value){
                          setState(() {
                            _bedno = value;
                          });
                        },)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Align(alignment: Alignment.topLeft, child: Text("ওয়াস রুম *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
               NumberStepper(initialValue: _washno, min: 0, max: 5, step:1, onChanged: (value){
                          setState(() {
                            _washno = value;
                          });
                        },)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Align(alignment: Alignment.topLeft, child: Text("বারিন্দা সংখ্যা ",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
               NumberStepper(initialValue: _barandano, min: 0, max: 5, step:1, onChanged: (value){
                          setState(() {
                            _barandano = value;
                          });
                        },)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Align(alignment: Alignment.topLeft, child: Text("ফ্লাটটি কত তলাতে *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
               NumberStepper(initialValue: _flatno, min: 0, max: 5, step:1, onChanged: (value){
                          setState(() {
                            _flatno = value;
                          });
                        },)
            ],
          ),
        ],
      );
   
  }
}

class Step2Form extends StatefulWidget {
  const Step2Form({super.key});

  @override
  State<Step2Form> createState() => _Step2FormState();
}

DateTime? rentFromTime ;
bool hasLift = false;
bool hasGenarators = false;
bool hasSecurityGuard = false;
bool hasParking = false;
bool hasGas = false;
bool hasWifi = false;
bool rentnego = false;
final TextEditingController rentamount = TextEditingController();
  final TextEditingController sqaurefeet = TextEditingController();
  final TextEditingController electricitybill = TextEditingController();
  final TextEditingController gasbill = TextEditingController();
  final TextEditingController waterbill = TextEditingController();
  final TextEditingController serviceCharge = TextEditingController();
  final TextEditingController dateofvacent = TextEditingController();
  final TextEditingController postdeadline = TextEditingController();
  final TextEditingController areaname = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController description  = TextEditingController();
  final List<String> religion = ['ইসলাম', 'হিন্দু', 'খ্রিষ্টান', 'বৌদ্ধ', 'যেকোনো'];
  String selectedreligion = "";
  int? religionIndex ;
class _Step2FormState extends State<Step2Form> {

   DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        rentFromTime =picked;
      });
      print('data e chap dise $picked');
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(

      checkboxShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
      title: Text("লিফট সুবিধা",style: TextStyle(fontSize: 14,  fontWeight: FontWeight.w500),),
      value: hasLift,
      onChanged: (value) {
        setState(() {
       hasLift = value!;
      });
      },
    ),
    CheckboxListTile(
      checkboxShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
      title: Text("জেনেরেটর সুবিধা",style: TextStyle(fontSize: 14,  fontWeight: FontWeight.w500),),
      value: hasGenarators,
      onChanged: (value) {
        setState(() {
       hasGenarators = value!;
      });
      },
    ),
    CheckboxListTile(
      checkboxShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
      title: Text("সিকিউরিটি গার্ড",style: TextStyle(fontSize: 14,  fontWeight: FontWeight.w500),),
      value: hasSecurityGuard,
      onChanged: (value) {
        setState(() {
       hasSecurityGuard = value!;
      });
      },
    ),
    CheckboxListTile(
      checkboxShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
      title: Text("পার্কিং সুবিধা",style: TextStyle(fontSize: 14,  fontWeight: FontWeight.w500),),
      value: hasParking,
      onChanged: (value) {
        setState(() {
       hasParking = value!;
      });
      },
    ),
    CheckboxListTile(
      checkboxShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
      title: Text("গ্যাস সুবিধা",style: TextStyle(fontSize: 14,  fontWeight: FontWeight.w500),),
      value: hasGas,
      onChanged: (value) {
        setState(() {
       hasGas = value!;
      });
      },
    ),
    CheckboxListTile(
      checkboxShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
      title: Text("WIFI সুবিধা",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
      value: hasWifi,
      onChanged: (value) {
        setState(() {
       hasWifi = value!;
      });
      },
    ),
    Align(alignment: Alignment.topLeft, child: Text("ভাড়ার পরিমান *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    Padding(padding: EdgeInsets.only(top: 10)),
    Container(
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    child: Column(
      children:[
        TextFormField(
          controller: rentamount,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.currency_pound_outlined,color: Colors.black38),
            ),
          ),
          ]
    ),
    ),
    Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          value: rentnego,
          onChanged: (value) {
            setState(() {
           rentnego = value!;
          });
          },
        ),
        Text("আলোচনা সাপেক্ষে")
      ],
    ),
    Align(alignment: Alignment.topLeft, child: Text("স্কয়ার ফিট",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    Padding(padding: EdgeInsets.only(top: 10)),
    Container(
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    child: Column(
      children:[
        TextFormField(
          controller: sqaurefeet,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
          ]
    ),
    ),
    Padding(padding: EdgeInsets.only(top: 10)),
    Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              children: [
                Align(alignment: Alignment.topLeft, child: Text("বিদ্যুৎ বিল",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                padding: EdgeInsets.only(left: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
              child: Column(
                children:[
                  TextFormField(
                    controller: electricitybill,
              decoration: InputDecoration(
                icon: Icon(Icons.currency_pound_outlined,color: Colors.black38),
                border: InputBorder.none,
              ),
            ),
            ]
              ),
              ),
              ],
            ),
          )
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left : 5),
            child: Column(
              children: [
              Align(alignment: Alignment.topLeft, child: Text("গ্যাস বিল",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                padding: EdgeInsets.only(left: 10),
                 width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
              child: Column(
                children:[
                  TextFormField(
                    controller: gasbill,
              decoration: InputDecoration(
                icon: Icon(Icons.currency_pound_outlined,color: Colors.black38),
                border: InputBorder.none,
              ),
            ),
            ]
              ),
              ),
              ],
            ),
          )
        )
      ],
    ),
    Padding(padding: EdgeInsets.only(top: 10)),
    Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              children: [
                Align(alignment: Alignment.topLeft, child: Text("পানির বিল",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                padding: EdgeInsets.only(left: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
              child: Column(
                children:[
                  TextFormField(
                    controller: waterbill,
              decoration: InputDecoration(
                icon: Icon(Icons.currency_pound_outlined,color: Colors.black38),
                border: InputBorder.none,
              ),
            ),
            ]
              ),
              ),
              ],
            ),
          )
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left : 5),
            child: Column(
              children: [
              Align(alignment: Alignment.topLeft, child: Text("সার্ভিস চার্জ",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                padding: EdgeInsets.only(left: 10),
                 width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
              child: Column(
                children:[
                  TextFormField(
                    controller: serviceCharge,
              decoration: InputDecoration(
                icon: Icon(Icons.currency_pound_outlined,color: Colors.black38),
                border: InputBorder.none,
              ),
            ),
            ]
              ),
              ),
              ],
            ),
          )
        )
      ],
    ),
    Padding(padding: EdgeInsets.only(top: 10)),
    Align(alignment: Alignment.topLeft, child: Text("কোন তারিখ থেকে ভাড়া হবে *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    Padding(padding: EdgeInsets.only(top: 10)),
    Container(
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    child: Column(
      children:[
        TextFormField(
          readOnly: true,
          onTap:(){
            _selectDate(context);
            String time = DateFormat('MMMM dd, yyyy').format(rentFromTime!);
            dateofvacent.text= time;
            },
          controller: dateofvacent,
            decoration: InputDecoration(
              hintText:'$rentFromTime'  ,
              border: InputBorder.none,
              
            ),
            
          ),
          ]
    ),
    ),
    // Padding(padding: EdgeInsets.only(top: 10)),
    // Align(alignment: Alignment.topLeft, child: Text("কোন তারিখ পর্যন্ত বিজ্ঞাপন সাইটে থাকবে *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    // Padding(padding: EdgeInsets.only(top: 10)),
    // Container(
    //   padding: EdgeInsets.only(left: 10),
    //   width: double.infinity,
    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    // child: Column(
    //   children:[
    //     TextFormField(
    //       onTap: () => print(selectedDate),
    //       controller: postdeadline,
    //         decoration: InputDecoration(
    //           hintText: "তারিখ লিখুন",
    //           border: InputBorder.none,
              
    //         ),
    //       ),
    //       ]
    // ),
    // ),
    Padding(padding: EdgeInsets.only(top: 10)),
    Align(alignment: Alignment.topLeft, child: Text("এলাকা *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    Padding(padding: EdgeInsets.only(top: 10)),
    Container(
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    child: Column(
      children:[
        TextFormField(
          controller:areaname,
            decoration: InputDecoration(
              hintText: "এলাকার নাম",
              border: InputBorder.none,
              
            ),
          ),
          ]
    ),
    ),
    Padding(padding: EdgeInsets.only(top: 10)),
    Align(alignment: Alignment.topLeft, child: Text("বাসার ঠিকানা *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    Padding(padding: EdgeInsets.only(top: 10)),
    Container(
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    child: Column(
      children:[
        SizedBox(
          height: 100,
          child: TextFormField(
            controller: address,
              decoration: InputDecoration(
                hintText: "বাসার ঠিকানা লিখুন",
                border: InputBorder.none,
                
              ),
            ),
        ),
          ]
    ),
    ),
    Padding(padding: EdgeInsets.only(top: 10)),
    Align(alignment: Alignment.topLeft, child: Text("বাসার বর্ণনা *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
    Padding(padding: EdgeInsets.only(top: 10)),
    Container(
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.black12)),
    child: Column(
      children:[
        SizedBox(
          height: 100,
          child: TextFormField(
            controller: description,
              decoration: InputDecoration(
                hintText: "বাসার বর্ণনা  লিখুন",
                border: InputBorder.none,
                
              ),
            ),
        ),
          ]
    ),
    ),
    Align(alignment: Alignment.topLeft, child: Text("আপনি কি ভাড়া দিতে চান *",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),)),
          SizedBox(
            height: 80,
            child: ListView.builder(
            itemCount: religion.length, 
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              final Religion= religion[index];
              return Padding(padding: EdgeInsets.all(8),
              child: ChoiceChip(
                label: Text(Religion),
                selectedColor: Colors.green.shade300,
                selected: religionIndex == index,
                onSelected: (bool Selected)
                { setState(() {
                   religionIndex = Selected ? index : 0;
                   selectedreligion = Religion;
                });
                 
                    },
                
                ),
              );
            }),
          ),
      ],
    );
  }
}

class Step3Form extends StatefulWidget {
  const Step3Form({super.key});

  @override
  State<Step3Form> createState() => _Step3FormState();
}

String ? Uid ;
void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    Uid =uid;
    print('uid is $Uid');
    DocumentSnapshot? documentSnapshot = await FirebaseFirestore.instance
      .collection('postserial')
      .doc('postnumber')
      .get();
int? postno;
final getpostnumber;
getpostnumber = documentSnapshot.data();
postno = getpostnumber['postno'];
currentpost = postno;
  }
class _Step3FormState extends State<Step3Form> {

String errormsg = '';
List<File> _imageFiles = [];

  Future<void> _getImages() async {
    checkLoginStatus();
FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    
    final status = true;

    if (status== true) {
      // Permission granted, you can now access the photo gallery
      List<XFile> imageFiles = [];
      try {
        imageFiles = await ImagePicker().pickMultiImage();
      } on Exception catch (e) {
        print(e.toString());
      }

      if (!mounted) return;

      List<File> convertedImageFiles = [];
      for (var imageFile in imageFiles) {
        convertedImageFiles.add(File(imageFile.path));
      }

      setState(() {
        _imageFiles = convertedImageFiles;
      });
    } else if (status== false ) {
      // Permission denied or permanently denied
      // You can provide a user-friendly message or open app settings here
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFiles.isNotEmpty
                ? Column(
                    children: _imageFiles.map((file) {
                      return Image.file(
                        file,
                        height: 200,
                      );
                    }).toList(),
                  )
                : Text('No images selected'),
            ElevatedButton(
              onPressed: _getImages,
              child: Text('Select Images'),
            ),
            ElevatedButton(
              onPressed: () {

            if(_imageFiles.isEmpty || rentamount.text.isEmpty||sqaurefeet.text.isEmpty||electricitybill.text.isEmpty||gasbill.text.isEmpty||waterbill.text.isEmpty||serviceCharge.text.isEmpty||rentFromTime.toString().isEmpty||areaname.text.isEmpty||address.text.isEmpty||description.text.isEmpty||selectedreligion.isEmpty||_selectedrentType.isEmpty||_bedno.toString().isEmpty||_washno.toString().isEmpty||_barandano.toString().isEmpty||_flatno.toString().isEmpty){
              setState(() {
                AlertDialog(actions: [Text('Please fill all fields.')],);
                // errormsg = 'Please fill all fields.';
              });
              return ;
            }else{

checkLoginStatus();
addPost(Uid!, postdetails,_imageFiles);
Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LandingPage(),
        ),
      );
            }
                

              },
              child: Text('Upload Images'),
            ),
            Text(
                  errormsg,
                  style: TextStyle(color: Colors.red),
                ),
          //  
           ] ),
      );

  }
}



class NumberStepper extends  StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final int step;

  final Function(int) onChanged;

  const NumberStepper({
    super.key,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged
  });

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  int _currentValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentValue = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: (){
            setState(() {
              if(_currentValue > widget.min){
                _currentValue -= widget.step;
              }
              widget.onChanged (_currentValue);
            });
        }, icon: Icon(Icons.remove_circle,color: Colors.black,)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12)
          ),
          child: Text(
          _currentValue.toString()+" টি",
          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
        ),
        ),
        
        IconButton(onPressed: (){
          setState(() {
            if(_currentValue < widget.max){
              _currentValue += widget.step;
            }
            widget.onChanged (_currentValue);
          });
        }, icon: Icon(Icons.add_circle,color: Colors.black)),
      ],
    );

  }
}

var postdetails = {

  "UID" : Uid,
  "postno": currentpost,
  "lift" : hasLift,
  "generator": hasGenarators,
  "securityGuard": hasSecurityGuard,
  "parking": hasParking,
  "gas": hasGas,
  "wifi": hasWifi,
  "rent": rentamount.text.trim(),
  "rentNegotiation": rentnego,
  "houseMeasurement":sqaurefeet.text.trim(),
  "electricityBill": electricitybill.text.trim(),
  "gasBill": gasbill.text.trim(),
  "waterBill": waterbill.text.trim(),
  "servicingCost": serviceCharge.text.trim(),
  "rentDate": rentFromTime,
  // dateofvacent.text.trim(),
  "rentalArea": areaname.text.trim(),
  "rentalAddress": address.text.trim(),
  "houseDetails": description.text.trim(),
  "Religion": selectedreligion,
  "rentType": _selectedrentType,
  "rentPeopleType": _selectedApplicableFor,
  "bedroom": _bedno,
  "washroom": _washno,
  "baranda": _barandano,
  "flatFloor": _flatno,
};

var otherFacilitiesData = <String, bool>{
  "lift": hasLift,
  "generator": hasGenarators,
  "securityGuard": hasSecurityGuard,
  "parking": hasParking,
  "gas": hasGas,
  "wifi": hasWifi,
};
var rentalDetailsData = <String, dynamic>{
  "rent": rentamount.text.trim(),
  "rentNegotiation": rentnego,
  "houseMeasurement":sqaurefeet.text.trim(),
  "electricityBill": electricitybill.text.trim(),
  "gasBill": gasbill.text.trim(),
  "waterBill": waterbill.text.trim(),
  "servicingCost": serviceCharge.text.trim(),
  "rentDate": dateofvacent.text.trim(),
  "advertisementDuration": postdeadline.text.trim(),
  "rentalArea": areaname.text.trim(),
  "rentalAddress": address.text.trim(),
  "houseDetails": description.text.trim(),
  "Religion": selectedreligion,
};
var rentalData = <String, dynamic>{
  "rentType": _selectedrentType,
  "rentPeopleType": _selectedApplicableFor,
  "bedroom": _bedno,
  "washroom": _washno,
  "baranda": _barandano,
  "flatFloor": _flatno,
};
createPost(String uid, Map<String, dynamic> data) async {
  var docRef = FirebaseFirestore.instance

      .collection("posts")
      .doc('allposts')
      // .collection("post")
      // .doc()
      .collection("Rental-Details")
      .doc();
  await docRef.set(data);
}
createRentalType(String uid, Map<String, dynamic> data) async {
  var docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      // .collection("post")
      // .doc()
      .collection("Rental-Type")
      .doc();
  await docRef.set(data);

  await FirebaseFirestore.instance.collection("users").doc(uid).set({"userId":id});
}

/// Create Other Facilities ....
createRentalOtherFacilities(String uid, Map<String, bool> data) async {
  var docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      // .collection("post")
      // .doc()
      .collection("Other-Facility")
      .doc();
  await docRef.set(data);
  await FirebaseFirestore.instance.collection("users").doc(uid).set({"userId":id});
}

/// Create Rental Details ....
createRentalDetails(String uid, Map<String, dynamic> data) async {
  var docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      // .collection("post")
      // .doc()
      .collection("Rental-Details")
      .doc();
  await docRef.set(data);
  await FirebaseFirestore.instance.collection("users").doc(uid).set({"userId":id});
}




class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  List<File> _imageFiles = [];

  Future<void> _getImages() async {
FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    
    final status = true;

    if (status== true) {
      // Permission granted, you can now access the photo gallery
      List<XFile> imageFiles = [];
      try {
        imageFiles = await ImagePicker().pickMultiImage();
      } on Exception catch (e) {
        print(e.toString());
      }

      if (!mounted) return;

      List<File> convertedImageFiles = [];
      for (var imageFile in imageFiles) {
        convertedImageFiles.add(File(imageFile.path));
      }

      setState(() {
        _imageFiles = convertedImageFiles;
      });
    } else if (status== false ) {
      // Permission denied or permanently denied
      // You can provide a user-friendly message or open app settings here
      openAppSettings();
    }
  }

  // Implement your image upload logic here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Image Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFiles.isNotEmpty
                ? Column(
                    children: _imageFiles.map((file) {
                      return Image.file(
                        file,
                        height: 200,
                      );
                    }).toList(),
                  )
                : Text('No images selected'),
            ElevatedButton(
              onPressed: _getImages,
              child: Text('Select Images'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement your image upload logic here
                // You can use _imageFiles for the list of selected files
              },
              child: Text('Upload Images'),
            ),
          ],
        ),
      ),
    );
  }
}






//extra experiments

Future<void> addPost(String uid, Map<String, dynamic> postData, List<File> images) async {
  int? postno;

  final getpostnumber ;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

DocumentSnapshot? documentSnapshot = await FirebaseFirestore.instance
      .collection('postserial')
      .doc('postnumber')
      .get();

getpostnumber = documentSnapshot.data();
postno = getpostnumber['postno'];
int incriment = postno!+1;


  // Add post data to Firestore
  await firestore.collection('posts').doc('post$postno').set(postData);






  for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final imageRef = storage.ref().child('posts/post$postno/image$i.jpg');
      await imageRef.putFile(image);
    }
 Map<String, dynamic> updatepostno = {'postno' : incriment};
 await firestore.collection('postserial').doc('postnumber').update(updatepostno);
}

