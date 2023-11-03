import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/blocs/profile_bloc/profile_bloc.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:impak_mobile/models/user_data.dart';
import 'package:impak_mobile/pages/widgets/list_view_fragment.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  String name = '';

  @override
  void initState() {
    super.initState();
    _populateTextFields();
  }

  void _populateTextFields() {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileUser) {
      final user = state.user;
      setState(() {
        name = '${user.firstName} ${user.lastName}';
      });
      _firstName.text = user.firstName;
      _lastName.text = user.lastName;
      _email.text = user.email;
      _phone.text = user.phone;
    }
  }

  Future<void> _updateProfile() async {
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty) {
      return _showError('Please fill all the fields');
    }

    final response = await GetIt.instance
        .get<ChopperClient>()
        .getService<ApiService>()
        .updateProfile({
      'first_name': _firstName.text,
      'last_name': _lastName.text,
      'email': _email.text,
      'phone': _phone.text,
    });

    try {
      if (response.error != null) {
        final error = jsonDecode(response.error.toString());

        return _showError(error['message']);
      }

      final parsed = UserData.fromJson(
        response.body['data'],
      );

      if (mounted) {
        context.read<ProfileBloc>().add(ProfileStore(parsed));
      }

      _showSuccess();
    } catch (e) {
      return _showError('Encountered an unexpected error!');
      // no-op
    }
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
            Radius.circular(30),
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
              'Profile Updated',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xff141414),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'You successfully updated\nyour profile details.',
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
  }

  @override
  Widget build(BuildContext context) {
    return ListViewFragment(
      name: 'Update Profile',
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
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff80877B).withOpacity(0.23),
                              offset: const Offset(0, 3.51724),
                              blurRadius: 6.44828,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 80 - 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 80 - 2 - 20,
                            backgroundImage: NetworkImage(
                              'https://ui-avatars.com/api/?name=$name&format=png',
                            ),
                            backgroundColor: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   right: 0,
                      //   bottom: 0,
                      //   child: Container(
                      //     height: 30,
                      //     width: 30,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       gradient: LinearGradient(
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //         colors: [
                      //           Color(0xff7D75FF),
                      //           Color(0xff4F46E5),
                      //         ],
                      //       ),
                      //     ),
                      //     child: const Icon(
                      //       FontAwesomeIcons.plus,
                      //       color: Colors.white,
                      //       size: 18,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'First Name',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _firstName,
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
                    hintText: "John Doe",
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Last Name',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _lastName,
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
                    hintText: "John Doe",
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _email,
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
                    hintText: "jdoe@impak.app",
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Phone',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phone,
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
                    hintText: "+63 912 345 6789",
                    fillColor: Colors.white70,
                  ),
                ),
                // const SizedBox(height: 20),
                // Text(
                //   'Gender',
                //   style: GoogleFonts.inter(
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // TextField(
                //   decoration: InputDecoration(
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(60.0),
                //       borderSide:
                //           const BorderSide(color: Colors.grey, width: 0.0),
                //     ),
                //     border: const OutlineInputBorder(),
                //     filled: true,
                //     contentPadding: const EdgeInsets.symmetric(
                //       horizontal: 24,
                //       vertical: 12,
                //     ),
                //     hintStyle: TextStyle(color: Colors.grey[800]),
                //     hintText: "I prefer not to say",
                //     fillColor: Colors.white70,
                //   ),
                // ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: _updateProfile,
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
