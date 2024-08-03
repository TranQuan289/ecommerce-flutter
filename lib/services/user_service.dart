import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(UserModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          name: user.name,
          phone: user.phone,
          email: user.email,
          password: user.password,
          dateOfBirth: user.dateOfBirth,
          role: 'member');

      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toJson());
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return UserModel(
          id: userCredential.user!.uid,
          name: userData['name'],
          phone: userData['phone'],
          email: userData['email'],
          password: '',
          dateOfBirth: userData['dateOfBirth'],
          role: userData['role'],
        );
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
    return null;
  }
}
