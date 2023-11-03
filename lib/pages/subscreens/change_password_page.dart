import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:impak_mobile/pages/widgets/list_view_fragment.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscruingCurrentPassword = true;
  bool _obscuringNewPassword = true;
  bool _obscuringConfirmNewPassword = true;

  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmNewPassword = TextEditingController();

  Future<void> _changePassword() async {
    if (_currentPassword.text.isEmpty ||
        _newPassword.text.isEmpty ||
        _confirmNewPassword.text.isEmpty) {
      return _showError('Please fill all the fields');
    }

    final response = await GetIt.instance
        .get<ChopperClient>()
        .getService<ApiService>()
        .changePassword({
      'old_password': _currentPassword.text,
      'new_password': _newPassword.text,
      'confirm_password': _confirmNewPassword.text,
    });

    try {
      if (response.error != null) {
        final error = jsonDecode(response.error.toString());

        return _showError(error['message']);
      }

      _showSuccess();
    } catch (e) {
      return _showError('Encountered an unexpected error!');
      // no-op
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/success.png',
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 17),
            Text(
              'Password Updated',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xff141414),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'You successfully changed\nyour password.',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w300,
                fontSize: 13.5,
                color: const Color(0xff787878),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );

    return;
  }

  void _showError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(28),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 17),
            Text(
              error,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xff141414),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              'Kindly double check all the inputted fields.',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w300,
                fontSize: 13.5,
                color: const Color(0xff787878),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );

    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListViewFragment(
      name: 'Change Password',
      hasBack: true,
      hasSearch: false,
      child: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 100.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Text(
                  'Current Password',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _currentPassword,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "",
                    fillColor: Colors.white70,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscruingCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscruingCurrentPassword =
                              !_obscruingCurrentPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscruingCurrentPassword,
                ),
                const SizedBox(height: 20),
                Text(
                  'New Password',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _newPassword,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "",
                    fillColor: Colors.white70,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscuringNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscuringNewPassword = !_obscuringNewPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscuringNewPassword,
                ),
                const SizedBox(height: 20),
                Text(
                  'Confirm New Password',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmNewPassword,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "",
                    fillColor: Colors.white70,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscuringConfirmNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscuringConfirmNewPassword =
                              !_obscuringConfirmNewPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscuringConfirmNewPassword,
                ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: _changePassword,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xff6366F1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
