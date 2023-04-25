import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  child: Column(
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
                                  backgroundImage: const NetworkImage(
                                    'https://api.dicebear.com/6.x/pixel-art/png',
                                  ),
                                  backgroundColor: Colors.grey.shade900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'John Doe',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'john@impak.com',
                                  style: TextStyle(
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
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffE2E8F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(FontAwesomeIcons.bell),
                          ),
                          title: const Text(
                            'In-app Notifications',
                            style: TextStyle(
                              color: Color(0xff787878),
                              fontSize: 14,
                            ),
                          ),
                          trailing: CupertinoSwitch(
                            value: true,
                            activeColor: const Color(0xff6366F1),
                            onChanged: (data) {},
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffE2E8F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.email_outlined),
                          ),
                          title: const Text(
                            'Email Notifications',
                            style: TextStyle(
                              color: Color(0xff787878),
                              fontSize: 14,
                            ),
                          ),
                          trailing: CupertinoSwitch(
                            value: true,
                            activeColor: const Color(0xff6366F1),
                            onChanged: (data) {},
                          ),
                        ),
                        const SizedBox(height: 16),
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
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF1F0),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xffE11D48),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
