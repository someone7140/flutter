import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleAuthService {
  static GoogleSignIn getGoogleSignIn() {
    return GoogleSignIn(
      clientId: dotenv.get('GOOGLE_CLIENT_ID'),
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }
}
