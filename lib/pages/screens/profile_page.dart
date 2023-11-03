import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:impak_mobile/blocs/profile_bloc/profile_bloc.dart';
import 'package:impak_mobile/pages/sign_in_page.dart';
import 'package:impak_mobile/pages/subscreens/change_password_page.dart';
import 'package:impak_mobile/pages/subscreens/update_profile_page.dart';
import 'package:impak_mobile/pages/widgets/list_view_fragment.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListViewFragment(
      name: 'Profile',
      hasSearch: false,
      child: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 100.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEBEBEB)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      final user = (state as ProfileUser).user;
                      final name = '${user.firstName} ${user.lastName}';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff80877B)
                                            .withOpacity(0.23),
                                        offset: const Offset(0, 3.51724),
                                        blurRadius: 6.44828,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 50 - 20,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 48 - 20,
                                      backgroundImage: NetworkImage(
                                        Uri.encodeFull(
                                          'https://ui-avatars.com/api/?name=$name&format=png',
                                        ),
                                      ),
                                      backgroundColor: Colors.grey.shade900,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                    // const SizedBox(height: 4),
                                    // ElevatedButton(
                                    //   style: ElevatedButton.styleFrom(
                                    //     elevation: 0,
                                    //     backgroundColor: const Color(0xff6366F1),
                                    //   ),
                                    //   onPressed: () {},
                                    //   child: const Text(
                                    //     'Edit Profile',
                                    //     style: TextStyle(
                                    //       fontSize: 12,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0F172A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdateProfilePage(),
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffE2E8F0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(FontAwesomeIcons.user),
                              ),
                              title: const Text(
                                'Update Profile',
                                style: TextStyle(
                                  color: Color(0xff787878),
                                  fontSize: 14,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordPage(),
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffE2E8F0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.lock_outline),
                              ),
                              title: const Text(
                                'Change Password',
                                style: TextStyle(
                                  color: Color(0xff787878),
                                  fontSize: 14,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                            const SizedBox(height: 16),
                            // const Text(
                            //   'Notifications',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w600,
                            //     color: Color(0xff0F172A),
                            //   ),
                            // ),
                            // const SizedBox(height: 16),
                            // ListTile(
                            //   contentPadding: EdgeInsets.zero,
                            //   leading: Container(
                            //     decoration: BoxDecoration(
                            //       color: const Color(0xffE2E8F0),
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //     padding: const EdgeInsets.all(8),
                            //     child: const Icon(FontAwesomeIcons.bell),
                            //   ),
                            //   title: const Text(
                            //     'In-app Notifications',
                            //     style: TextStyle(
                            //       color: Color(0xff787878),
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            //   trailing: CupertinoSwitch(
                            //     value: true,
                            //     activeColor: const Color(0xff6366F1),
                            //     onChanged: (data) {},
                            //   ),
                            // ),
                            // ListTile(
                            //   contentPadding: EdgeInsets.zero,
                            //   leading: Container(
                            //     decoration: BoxDecoration(
                            //       color: const Color(0xffE2E8F0),
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //     padding: const EdgeInsets.all(8),
                            //     child: const Icon(Icons.email_outlined),
                            //   ),
                            //   title: const Text(
                            //     'Email Notifications',
                            //     style: TextStyle(
                            //       color: Color(0xff787878),
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            //   trailing: CupertinoSwitch(
                            //     value: true,
                            //     activeColor: const Color(0xff6366F1),
                            //     onChanged: (data) {},
                            //   ),
                            // ),
                            // const SizedBox(height: 16),
                            const Text(
                              'More',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff0F172A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              onTap: () {
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
                                          'assets/delete_confirmation.png',
                                          height: 120,
                                          width: 120,
                                        ),
                                        const SizedBox(height: 17),
                                        Text(
                                          'Are you sure?',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: const Color(0xff141414),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'This action will delete your account,\nand any data associated with it.',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 13.5,
                                            color: const Color(0xff787878),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 21),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xffC5C5C5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff6366F1),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const SignIn()),
                                                    (route) => false,
                                                  );
                                                },
                                                child: Text(
                                                  'Yes, Delete',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffFAECEB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xffE11D48),
                                ),
                              ),
                              title: const Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: Color(0xffE11D48),
                                  fontSize: 14,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () {
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
                              'assets/confirm.png',
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(height: 17),
                            Text(
                              'Log out of IMPAK?',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: const Color(0xff141414),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'You will be logged out of your account.',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w300,
                                fontSize: 13.5,
                                color: const Color(0xff787878),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 21),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: const Color(0xffC5C5C5),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff6366F1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                    ),
                                    onPressed: () {
                                      context
                                          .read<AuthenticationBloc>()
                                          .add(AuthenticationLogoutRequested());
                                    },
                                    child: Text(
                                      'Yes',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF1F0),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xffE11D48),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.signOutAlt,
                          size: 14,
                          color: Color(0xffE11D48),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xffE11D48),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
