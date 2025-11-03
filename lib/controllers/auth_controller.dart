import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ---------------- SIGN UP ----------------
  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': DateTime.now(),
          'signInMethod': 'email',
        });

        Get.snackbar('Success', 'Account created successfully');
        Get.offAll(() => HomeScreen());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ---------------- LOGIN ----------------
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Login successful');
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  ///GOOGLE SIGN-IN
  Future<void> signInWithGoogle() async {
    try {
      // Start the sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // cancelled

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Add user to Firestore if new
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'createdAt': DateTime.now(),
            'signInMethod': 'google',
          });
        }

        Get.snackbar('Success', 'Signed in with Google');
        Get.offAll(() => HomeScreen());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  ///CURRENT USER
  User? get currentUser => _auth.currentUser;
}
