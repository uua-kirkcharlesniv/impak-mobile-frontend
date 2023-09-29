import 'package:formz/formz.dart';

enum EmailInputValidationError { empty, badlyFormatted }

class EmailInput extends FormzInput<String, EmailInputValidationError> {
  const EmailInput.pure() : super.pure('');
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  @override
  EmailInputValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return EmailInputValidationError.empty;
    } else {
      if (!RegExp(
        r'^(?:\+?(?:0|\d{2,14})|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$',
      ).hasMatch(value)) {
        return EmailInputValidationError.badlyFormatted;
      }
    }

    return null;
  }
}
