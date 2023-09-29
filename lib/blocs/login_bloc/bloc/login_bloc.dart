import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';
import 'package:impak_mobile/inputs/formz/email_input.dart';
import 'package:impak_mobile/inputs/formz/password_input.dart';
import 'package:impak_mobile/repository/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<EmailChanged>(
      (event, emit) =>
          emit(state.copyWith(email: EmailInput.dirty(event.input))),
    );

    on<PasswordChanged>(
      (event, emit) =>
          emit(state.copyWith(password: PasswordInput.dirty(event.input))),
    );

    on<SubmitLogin>((event, emit) async {
      if (state.status.isValid) {
        emit(
          state.copyWith(submissionStatus: FormzStatus.submissionInProgress),
        );
        try {
          await _authenticationRepository.logIn(
            email: state.email.value,
            password: state.password.value,
          );
          final box = await Hive.openBox<dynamic>('login');
          await box.put('email', state.email.value);
          emit(state.copyWith(submissionStatus: FormzStatus.submissionSuccess));
        } on Exception catch (e) {
          emit(
            state.copyWith(
              submissionStatus: FormzStatus.submissionFailure,
              message: e.toString().replaceAll(RegExp('Exception: '), ''),
            ),
          );
        }
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
}
