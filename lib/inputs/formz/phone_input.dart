import 'package:formz/formz.dart';

enum PhoneInputValidationError { empty, badlyFormatted }

class PhoneInput extends FormzInput<String, PhoneInputValidationError> {
  const PhoneInput.pure() : super.pure('');
  const PhoneInput.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneInputValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PhoneInputValidationError.empty;
    } else if (!RegExp(r'^(9)\d{9}$').hasMatch(value)) {
      return PhoneInputValidationError.badlyFormatted;
    }
    return null;
  }
}
