import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impak_mobile/pages/screens/departments_page.dart';
import 'package:impak_mobile/pages/screens/groups_page.dart';
import 'package:impak_mobile/pages/screens/home_page.dart';
import 'package:impak_mobile/pages/screens/profile_page.dart';
import 'package:impak_mobile/pages/screens/survey_page.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: inactiveIcons(isActive: true),
        inactiveIcons: inactiveIcons(),
        color: Colors.white,
        height: 80,
        circleWidth: 60,
        activeIndex: tabIndex,
        circleColor: const Color(0xff6366F1),
        onTap: (index) {
          tabIndex = index;
          pageController.jumpToPage(tabIndex);
        },
        iconCurve: Curves.easeInOut,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: screens,
      ),
    );
  }

  List<Widget> get screens {
    return const [
      HomePage(),
      SurveyPage(),
      GroupsPage(),
      DepartmentsPage(),
      ProfilePage(),
    ];
  }

  List<Widget> inactiveIcons({
    bool isActive = false,
  }) {
    final colorFilter = isActive
        ? const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          )
        : null;

    return [
      SvgPicture.asset(
        'assets/icons/home.svg',
        semanticsLabel: 'Home',
        colorFilter: colorFilter,
      ),
      SvgPicture.asset(
        'assets/icons/survey.svg',
        semanticsLabel: 'Surveys',
        colorFilter: colorFilter,
      ),
      SvgPicture.asset(
        'assets/icons/group.svg',
        semanticsLabel: 'Groups',
        colorFilter: colorFilter,
      ),
      SvgPicture.asset(
        'assets/icons/department.svg',
        semanticsLabel: 'Departments',
        colorFilter: colorFilter,
      ),
      SvgPicture.asset(
        'assets/icons/user.svg',
        semanticsLabel: 'Profile',
        colorFilter: colorFilter,
      ),
    ]
        .map((e) => isActive
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: e,
              )
            : e)
        .toList();
  }
}
