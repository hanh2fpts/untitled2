part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class SendOtpInProcess extends LoginState{}

class SendOtpSuccess extends LoginState {}

class VerifyOtpSuccess extends LoginState {}
