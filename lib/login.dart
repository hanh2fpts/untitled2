import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/otp_verification_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  TextEditingController phoneNumberController = TextEditingController();

  sendOtp() async {
    var phoneNumber = '';
    if (phoneNumberController.text.startsWith('0')) {
      phoneNumber = phoneNumberController.text.substring(1);
    } else {
      phoneNumber = phoneNumberController.text;
    }
    await auth.verifyPhoneNumber(
        phoneNumber: '+84$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          if (e.code == 'invalid-phone-number') {
            print('phone number invalid');
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          isLoading.value = false;
          Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationPage(verificationId: verificationId, phoneNumber: phoneNumber)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 120));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/images/mobile.json',
                alignment: Alignment.topCenter,
                height: 160,
              ),
              const Text(
                'Your phone',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text('Please confirm your country code and enter your phone number.', style: TextStyle(fontSize: 16, color: Colors.black), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 20),
              TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneNumberController,
                  style: const TextStyle(fontSize: 20),
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                      prefixIcon: SizedBox(
                        width: 60,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '+84',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      hintText: 'Your phone number',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))))),
              const SizedBox(height: 10),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () {
                  isLoading.value = true;
                  sendOtp();
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18),
                )),
          ),
          ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, value, child) => Visibility(
                visible: isLoading.value,
                child: Center(
                    child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.black26,
                        child: const CircularProgressIndicator(
                          color: Colors.green,
                          backgroundColor: Colors.amber,
                        )))),
          )
        ]),
      ),
    );
  }
}
