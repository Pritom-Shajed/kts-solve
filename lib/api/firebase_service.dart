import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User registration
  Future<String?> registerUser(
      String name, String email, String password,String phone) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      await _firestore.collection('AllUsers').doc(userId).set({
        'name' : name,
        'email': email,
        'password': password, 
        'phone' : phone
      });

      return null; // Registration successful, return null for no error
    } catch (e) {
      return null; // Return the error message if registration fails
    }
  }

  // User login
  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success"; // Login successful, return null for no error
    } catch (e) {
      return null; // Return the error message if login fails
    }
  }

  // Get the current user ID
  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }

}