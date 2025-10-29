import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lablink/Home/splach.dart';
import 'package:lablink/Patient/Pages/ForgotPasswordPage.dart'
    show ForgotPasswordPage;
import 'package:lablink/Patient/Pages/patient_home.dart';
import 'package:lablink/Patient/Pages/patient_signup.dart';

class PatientSignin extends StatefulWidget {
  const PatientSignin({super.key});

  @override
  State<PatientSignin> createState() => _PatientSigninState();
}

class _PatientSigninState extends State<PatientSignin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;
  Future<void> signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientHome()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Username or password is invalid';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("Google Sign-In canceled");
        return;
      }

      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create new credentials for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase with Google credentials
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientHome()),
      );

      print("✅ Google Sign-In successful!");
    } catch (e) {
      print("❌ Error during Google Sign-In: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Splach();
                },
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 23.99, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.arimo().fontFamily,
                ),
              ),
              Text(
                'Log in to continue',
                style: TextStyle(
                  fontFamily: GoogleFonts.arimo().fontFamily,
                  color: Color(0xff9B9B9B),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Email',
                style: TextStyle(
                  fontFamily: GoogleFonts.arimo().fontFamily,
                  fontSize: 16,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(controller: _emailController  , hintText: 'Enter your email', icon:  Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator:(value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: GoogleFonts.arimo().fontFamily,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    buildTextField(controller: _passwordController, hintText: 'Enter your password', icon:  Icons.lock,
                    obscureText: true,
                    validator:(value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: GoogleFonts.arimo().fontFamily,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          
              SizedBox(height: 15),
              SizedBox(
                ///////////////////////////////
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BBA7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Log in',
                          style: TextStyle(
                            fontFamily: GoogleFonts.arimo().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    '  Or continue with  ',
                    style: TextStyle(
                      fontFamily: GoogleFonts.arimo().fontFamily,
                      fontSize: 15,
                      color: const Color(0xff9B9B9B),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
          
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/gg.png'),
                        fit: BoxFit.cover,
                        width: 69,
                      ),
                      Text(
                        ' Google',
                        style: TextStyle(
                          fontFamily: GoogleFonts.arimo().fontFamily,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(
                      fontFamily: GoogleFonts.arimo().fontFamily,
                      fontSize: 18,
                      color: const Color(0xff9B9B9B),
                    ),
                    children: [
                      TextSpan(
                        text: ' Sign up',
                        style: TextStyle(
                          fontFamily: GoogleFonts.arimo().fontFamily,
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientSignup(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }






  TextFormField buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF00BBA7), width: 1.5),
        ),
      ),
    );
  }

}




