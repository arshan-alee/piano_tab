import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyAuthenticationService {
  // Future authenticateWithFacebook() async {
  //   try {
  //     final AccessToken accessToken = await FacebookAuth.instance.login();
  //     final String authToken = accessToken.token;

  //     return authToken; // Return the Facebook access token to the server for verification
  //   } catch (e) {
  //     // Handle any errors during Facebook authentication
  //     return null;
  //   }
  // }

  // Future authenticateWithApple() async {
  //   try {
  //     final AuthorizationResult result = await SignInWithApple.authorizeScopes(['email']);
  //     final String authToken = result.credential.userIdentifier;

  //     return authToken; // Return the Apple user identifier to the server for verification
  //   } catch (e) {
  //     // Handle any errors during Apple authentication
  //     return null;
  //   }
  // }

  static Future<GoogleSignInAccount?> authenticateWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    try {
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser?.authentication;
      // final String? authToken = googleAuth?.idToken;
      return googleSignIn.signIn();
      // return authToken; // Return the Google ID token to the server for verification
    } catch (e) {
      // Handle any errors during Google authentication
      print(e);
      return null;
    }
  }
}
