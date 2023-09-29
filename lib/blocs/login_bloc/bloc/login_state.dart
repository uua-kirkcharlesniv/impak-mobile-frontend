part of 'login_bloc.dart';

class LoginState extends Equatable with FormzMixin {
  const LoginState({
    this.submissionStatus = FormzStatus.pure,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.message = '',
  });

  final FormzStatus submissionStatus;
  final EmailInput email;
  final PasswordInput password;
  final String message;

  LoginState copyWith({
    FormzStatus? submissionStatus,
    EmailInput? email,
    PasswordInput? password,
    String? message,
  }) {
    return LoginState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        email,
        password,
        message,
      ];

  @override
  List<FormzInput> get inputs => [email, password];
}
