import 'package:formz/formz.dart';

enum PasswordInputValidationError { empty, weak }

class PasswordInput extends FormzInput<String, PasswordInputValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordInputValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordInputValidationError.empty;
    } else if (value.length < 8) {
      return PasswordInputValidationError.weak;
    }

    return null;
  }
}
