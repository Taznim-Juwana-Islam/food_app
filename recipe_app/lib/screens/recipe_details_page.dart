import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class RecipeDetailsPage extends StatefulWidget {
  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  User? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  Future<void> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      setState(() {
        user = _auth.currentUser;
      });
    }
  }

  Future<void> _signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final credential = FacebookAuthProvider.credential(accessToken.token);
      await _auth.signInWithCredential(credential);
      setState(() {
        user = _auth.currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Details')),
      body: Center(
        child: user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please log in to view details'),
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: Text('Sign in with Google'),
                  ),
                  ElevatedButton(
                    onPressed: _signInWithFacebook,
                    child: Text('Sign in with Facebook'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${user?.displayName}'),
                  // Display your recipe details here
                  Text('Recipe details go here...'),
                  ElevatedButton(
                    onPressed: () {
                      _auth.signOut();
                      setState(() {
                        user = null;
                      });
                    },
                    child: Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}
