part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  const EmailChanged(this.input);

  final String input;
}

class PhoneChanged extends LoginEvent {
  const PhoneChanged(this.input);

  final String input;
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.input);

  final String input;
}

class SubmitLogin extends LoginEvent {}

class VerifyPhoneNumber extends LoginEvent {
  const VerifyPhoneNumber(this.input);

  final String input;
}

class VerifyOTP extends LoginEvent {
  const VerifyOTP(this.otp, this.phone);

  final String otp;
  final String phone;
}
