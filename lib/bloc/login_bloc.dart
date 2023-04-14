import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled2/main.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //ValueNotifier<bool> isLoading = ValueNotifier(false);
  static String verificationId = '';
  String phoneNumber = '';
  bool isComplete = false;
  TextEditingController pinController = TextEditingController();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});
    on<SendOtpEvent>(sendOtp);
    on<VerifyOtpEvent>(verifyOtp);
  }

  void sendOtp(SendOtpEvent event, Emitter<LoginState> emit) async {
    var phone = event.phoneNumber;
    phoneNumber = phone.startsWith('0') ? phone.substring(1) : phone;
    await auth.verifyPhoneNumber(
        phoneNumber: '+84$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          pinController.setText(credential.smsCode.toString());
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          //isLoading.value = false;
          if (e.code == 'invalid-phone-number') {
            print('phone number invalid');
          }
        },
        codeSent: (verificationid, forceResendingToken) async {
          verificationId = verificationid;
          isComplete = true;
          print('verificationId : $verificationId');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 120));
    emit(SendOtpSuccess());
  }

  void verifyOtp(VerifyOtpEvent event, Emitter<LoginState> emit) async {
    try {
      print('gia tri khi truyen vao :$verificationId');
      print(pinController.text);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: pinController.text);
      await auth.signInWithCredential(credential).then((value) {
        if (value.user != null) {
          emit(VerifyOtpSuccess());
        }
      });
    } catch (e) {}
  }
}
