import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:impak_mobile/blocs/profile_bloc/profile_bloc.dart';
import 'package:impak_mobile/pages/screens/add_entry_page.dart';
import 'package:impak_mobile/pages/screens/hope_scale_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: SpeedDial(
          icon: Icons.add,
          backgroundColor: const Color(0xff7C74FF),
          activeIcon: Icons.close,
          spacing: 3,
          children: [
            SpeedDialChild(
              child: const Icon(
                FontAwesomeIcons.pen,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: const Color(0xff7C74FF),
              label: 'Add Journal Entry',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const AddEntryPage();
                    },
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(
                FontAwesomeIcons.faceSmile,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              label: 'Hope Scale',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HopeScalePage();
                    },
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(CupertinoIcons.sun_dust),
              backgroundColor: Colors.amber,
              label: 'Optimism Test',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xffF2F1FF),
                      const Color(0xffF2F1FF),
                      const Color(0xffD9D9D9).withOpacity(0),
                      const Color(0xffD9D9D9).withOpacity(0),
                    ],
                  ),
                )),
          ),
          Positioned.fill(
            child: AnimationLimiter(
              child: SafeArea(
                top: true,
                bottom: false,
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final user = (state as ProfileUser).user;
                    final name = '${user.firstName} ${user.lastName}';
                    return CustomScrollView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(29),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Color(0xff68298C),
                                      radius: 22.5,
                                      child: Icon(
                                        FontAwesomeIcons.building,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Good day,'),
                                        Text(
                                          user.firstName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
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
                                        radius: 22.5,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 21.5,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            Uri.encodeFull(
                                                'https://ui-avatars.com/api/?name=$name&format=png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 16),
                                // const HomepageSurveyWidget(
                                //   color: Color(0xff6EE7B7),
                                //   name:
                                //       "Dragon's Fury: The\nAdventurer's Opinion",
                                // ),
                                // const SizedBox(height: 15),
                                // const HomepageSurveyWidget(
                                //   color: Color(0xffFCD34D),
                                //   name:
                                //       "The Dragon's Realm: A\nSurvey of Gaming\nPreferences",
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Image.asset(
                                  'assets/timeline.png',
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Padding(
                                padding: EdgeInsets.only(left: 19),
                                child: Text(
                                  'My Mood',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff28221E),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        SliverStickyHeader(
                          header: const WeekHeaderWidget(
                            text: 'This week',
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final day =
                                    generateWeekTimelines(DateTime.now())[i];

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffEEEEEE),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      WeekTileLeading(
                                        day: day.day == DateTime.now().day
                                            ? 'Today'
                                            : DateFormat('EEE').format(day),
                                        number: DateFormat('dd').format(day),
                                        isToday: day.isToday(),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${Random().nextInt(99) + 1}% Stress Score',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: List.generate(
                                                Random().nextInt(3) + 1,
                                                (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16),
                                                  child: Image.asset(
                                                    'assets/faces_${Random().nextInt(4) + 1}.png',
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 18),
                                      WeekTileContinueButton(
                                        isToday: day.isToday(),
                                      ),
                                    ],
                                  ),
                                  // title: Text('List tile #$i'),
                                );
                              },
                              childCount:
                                  generateWeekTimelines(DateTime.now()).length,
                            ),
                          ),
                        ),
                        SliverStickyHeader(
                          header: const WeekHeaderWidget(
                            text: 'Last Week',
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final day = generateWeekTimelines(DateTime.now()
                                    .subtract(const Duration(days: 7)))[i];

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffEEEEEE),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      WeekTileLeading(
                                        day: day.day == DateTime.now().day
                                            ? 'Today'
                                            : DateFormat('EEE').format(day),
                                        number: DateFormat('dd').format(day),
                                        isToday: day.isToday(),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${Random().nextInt(99) + 1}% Stress Score',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: List.generate(
                                                Random().nextInt(3) + 1,
                                                (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16),
                                                  child: Image.asset(
                                                    'assets/faces_${Random().nextInt(4) + 1}.png',
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 18),
                                      WeekTileContinueButton(
                                        isToday: day.isToday(),
                                      ),
                                    ],
                                  ),
                                  // title: Text('List tile #$i'),
                                );
                              },
                              childCount: generateWeekTimelines(DateTime.now()
                                      .subtract(const Duration(days: 7)))
                                  .length,
                            ),
                          ),
                        ),
                        SliverStickyHeader(
                          header: const WeekHeaderWidget(
                            text: 'Sep 24 - 18',
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final day = generateWeekTimelines(DateTime.now()
                                    .subtract(const Duration(days: 14)))[i];

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffEEEEEE),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      WeekTileLeading(
                                        day: day.day == DateTime.now().day
                                            ? 'Today'
                                            : DateFormat('EEE').format(day),
                                        number: DateFormat('dd').format(day),
                                        isToday: day.isToday(),
                                      ),
                                      const SizedBox(width: 24),
                                      const WeekTileStressReport(),
                                      const SizedBox(width: 18),
                                      WeekTileContinueButton(
                                        isToday: day.isToday(),
                                      ),
                                    ],
                                  ),
                                  // title: Text('List tile #$i'),
                                );
                              },
                              childCount: generateWeekTimelines(DateTime.now()
                                      .subtract(const Duration(days: 14)))
                                  .length,
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 180),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeekTileStressReport extends StatelessWidget {
  const WeekTileStressReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Random().nextInt(99) + 1}% Stress Score',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              Random().nextInt(3) + 1,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  'assets/faces_${Random().nextInt(4) + 1}.png',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeekTileContinueButton extends StatelessWidget {
  const WeekTileContinueButton({
    super.key,
    required this.isToday,
  });

  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isToday
            ? null
            : Border.all(
                color: const Color(0xffEEEEEE),
              ),
        gradient: !isToday
            ? null
            : const LinearGradient(
                colors: [Color(0xff7C74FF), Color(0xff544BE8)],
              ),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: const Color(0xff80877B).withOpacity(0.23),
                  offset: const Offset(0, 3.51724),
                  blurRadius: 6.44828,
                ),
              ]
            : null,
      ),
      child: const Icon(
        Icons.chevron_right,
        color: Color(0xffEEEEEE),
        size: 32,
      ),
    );
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.day == this.day &&
        yesterday.month == this.month &&
        yesterday.year == this.year;
  }
}

DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

List<DateTime> generateWeekTimelines(DateTime start) {
  var timeline = <DateTime>[];

  final firstDay = findFirstDateOfTheWeek(start);
  final lastDay = findLastDateOfTheWeek(start);

  for (int i = firstDay.weekday - 1; i < lastDay.weekday; i++) {
    final day = firstDay.add(
      Duration(days: i),
    );

    if (day.isAfter(DateTime.now())) {
      continue;
    }

    timeline.add(
      day,
    );
  }

  timeline = timeline.reversed.toList();

  return timeline;
}

class WeekTileLeading extends StatelessWidget {
  const WeekTileLeading({
    super.key,
    required this.day,
    required this.number,
    this.isToday = false,
  });

  final String day;
  final String number;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: isToday ? const Color(0xff6366F1) : const Color(0xffB2B2BF),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          number,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30,
            color: isToday ? const Color(0xff6366F1) : const Color(0xffB2B2BF),
          ),
        )
      ],
    );
  }
}

class WeekHeaderWidget extends StatelessWidget {
  final String text;
  const WeekHeaderWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      color: const Color(0xff6366F1),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
