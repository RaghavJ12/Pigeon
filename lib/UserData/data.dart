
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
Get getdata=new Get();

class Get {
  Get._internal();

  static final Get _singleton = Get._internal();
  
  factory Get() => _singleton;
  String key, username, phoneno, photourl, emailid;

  toJson() {
    return {
      "name": username,
      "phone": phoneno,
      "email": emailid,
      "photourl": photourl,
      "id":key
    };
  }
}

 Future<FirebaseUser> getUser() async{

    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);

    // FirebaseUser user = await _auth.signInWithGoogle(
    //     idToken: googleSignInAuthentication.idToken,
    //     accessToken: googleSignInAuthentication.accessToken);


        getdata.username=user.displayName;
        getdata.emailid=user.email;
        getdata.phoneno=user.phoneNumber;
        getdata.photourl=user.photoUrl;
        getdata.key=user.uid;

    return user;

 }

// class Msgs{

// String

// }
