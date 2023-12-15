import 'dart:math';

import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:countup/countup.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:impak_mobile/blocs/profile_bloc/profile_bloc.dart';
import 'package:impak_mobile/chopper/api_service.dart';
import 'package:impak_mobile/pages/screens/add_entry_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var weeksList = <List<DateTime>>[];
  final _timelineData = <String, List<Map>>{};

  int _weeklyAverageValue = 0;
  String? _message;
  Map<String, int>? _weeklyAverages;

  // Sets to true when analytics is for month
  bool isViewingWeeklyAnalytics = true;

  @override
  void initState() {
    super.initState();
    _loadHomepageData();
  }

  void _loadHomepageData() async {
    _fetchAnalytics(isWeekly: isViewingWeeklyAnalytics);
    _generateTimeline();
  }

  Future<void> _generateTimeline() async {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is! ProfileUser) {
      throw UnsupportedError('ProfileState is not ProfileUser!');
    }

    final startDate = DateTime.parse(profileState.user.createdAt).toLocal();
    final endDate = DateTime.now().toLocal();

    DateTime currentWeekStart = startDate;

    while (currentWeekStart.isBefore(endDate)) {
      List<DateTime> week = generateWeekTimelines(currentWeekStart);
      weeksList.add(week);

      currentWeekStart = week.first.add(const Duration(days: 1));
    }

    setState(() {
      weeksList = weeksList.reversed.toList();
    });

    _fetchTimelineData();
  }

  Future<void> _fetchAnalytics({
    required bool isWeekly,
  }) async {
    final response = isViewingWeeklyAnalytics
        ? (await GetIt.instance
            .get<ChopperClient>()
            .getService<ApiService>()
            .getWeeklyAnalytics())
        : (await GetIt.instance
            .get<ChopperClient>()
            .getService<ApiService>()
            .getMonthlyAnalytics());

    final data = response.body;

    if (data != null && data is Map) {
      _processAnalyticsData(data);
    }
  }

  void _processAnalyticsData(Map data) {
    if (data.containsKey('average')) {
      try {
        _weeklyAverageValue = int.parse(data['average'].toString());
      } catch (e) {
        _weeklyAverageValue = 0;
      }
    }

    if (data.containsKey('message')) {
      try {
        setState(() {
          _message = data['message'];
        });
      } catch (e) {
        setState(() {
          _message = '';
        });
      }
    }

    if (data.containsKey('days')) {
      try {
        final days = Map<String, int>.from(data['days']);

        setState(() {
          _weeklyAverages = days;
        });
      } catch (e) {
        setState(() {
          _weeklyAverages = {};
        });
      }
    }
  }

  int? _determineFace(int average) {
    if (average > 0 && average <= 20) {
      return 1;
    } else if (average > 20 && average <= 40) {
      return 2;
    } else if (average > 40 && average <= 60) {
      return 3;
    } else if (average > 60 && average <= 80) {
      return 4;
    } else if (average > 80 && average <= 100) {
      return 5;
    }

    return null;
  }

  Future<void> _fetchTimelineData() async {
    final response = await GetIt.instance
        .get<ChopperClient>()
        .getService<ApiService>()
        .getTimeline();

    final timelineDataRaw = response.body['data'];

    if (timelineDataRaw is Map) {
      timelineDataRaw.forEach((key, value) {
        final entries = List<Map>.from(value);

        setState(() {
          _timelineData[key] = entries;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AddEntryPage();
                },
              ),
            ).then((value) {
              _loadHomepageData();
            });
          },
          backgroundColor: const Color(0xff7C74FF),
          child: const Icon(Icons.add),
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            child: Builder(
                                              builder: (context) {
                                                IconData icon = Icons
                                                    .calendar_month_outlined;
                                                String message =
                                                    'View Monthly Progress';

                                                if (!isViewingWeeklyAnalytics) {
                                                  icon = Icons.view_week;
                                                  message =
                                                      'View Weekly Progress';
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    final newState =
                                                        !isViewingWeeklyAnalytics;
                                                    setState(() {
                                                      isViewingWeeklyAnalytics =
                                                          newState;
                                                    });

                                                    _fetchAnalytics(
                                                      isWeekly: newState,
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffF8F4F3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 6,
                                                      vertical: 3,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          icon,
                                                          color: const Color(
                                                            0xff7C74FF,
                                                          ),
                                                          size: 14,
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          message,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10.5,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: Builder(builder: (context) {
                                              var message = '';

                                              if (isViewingWeeklyAnalytics) {
                                                final startDate =
                                                    findFirstDateOfTheWeek(
                                                        DateTime.now());
                                                final endDate =
                                                    findLastDateOfTheWeek(
                                                        DateTime.now());

                                                final format =
                                                    DateFormat('MMM dd');

                                                message =
                                                    '${format.format(startDate)} - ${format.format(endDate)}';
                                              } else {
                                                message =
                                                    'Month of ${DateFormat('MMMM').format(DateTime.now())}';
                                              }

                                              return RichText(
                                                text: TextSpan(
                                                  text: '',
                                                  children: [
                                                    TextSpan(
                                                      text: message,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                textAlign: TextAlign.end,
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: DashedCircularProgressBar
                                                .aspectRatio(
                                              aspectRatio: 1,
                                              progress: _weeklyAverageValue
                                                  .toDouble(),
                                              startAngle: 225,
                                              sweepAngle: 270,
                                              foregroundColor:
                                                  _weeklyAverageValue < 50
                                                      ? Colors.red
                                                      : Colors.green,
                                              backgroundColor:
                                                  const Color(0xffeeeeee),
                                              foregroundStrokeWidth: 10,
                                              backgroundStrokeWidth: 10,
                                              animation: true,
                                              seekSize: 6,
                                              seekColor:
                                                  const Color(0xffeeeeee),
                                              child: Center(
                                                child: Builder(
                                                  builder: (context) => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Countup(
                                                        begin: 0,
                                                        end: _weeklyAverageValue
                                                            .toDouble(),
                                                        duration:
                                                            const Duration(
                                                          milliseconds: 1250,
                                                        ),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 26,
                                                        ),
                                                        suffix: '%',
                                                      ),
                                                      const Text(
                                                        'Mood Score',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _message ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Builder(builder: (context) {
                                                  final mood = _determineFace(
                                                      _weeklyAverageValue);

                                                  if (mood == null) {
                                                    return const SizedBox();
                                                  }

                                                  return Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/faces_$mood.png',
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Expanded(
                                                        child: Text(
                                                          'is your average mood this period.',
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 150,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ...List.generate(
                                                  5,
                                                  (index) => Image.asset(
                                                    'assets/faces_${index + 1}.png',
                                                    height: 22.5,
                                                  ),
                                                ).reversed.toList(),
                                                const SizedBox(height: 6),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: List.generate(
                                                _weeklyAverages
                                                        ?.entries.length ??
                                                    0,
                                                (index) {
                                                  final entry = _weeklyAverages!
                                                      .entries
                                                      .toList()[index];

                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        child: FAProgressBar(
                                                          size: 20,
                                                          direction:
                                                              Axis.vertical,
                                                          verticalDirection:
                                                              VerticalDirection
                                                                  .up,
                                                          currentValue: entry
                                                              .value
                                                              .toDouble(),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xffC7D2FE),
                                                          progressColor:
                                                              const Color(
                                                                  0xff6366F1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            20,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        entry.key
                                                            .split('/')
                                                            .take(2)
                                                            .join('/'),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 9,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
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
                        ...weeksList.mapIndexed(
                          (idx, e) {
                            var headerText = '';
                            if (idx == 0) {
                              headerText = 'This week';
                            } else if (idx == 1) {
                              headerText = 'Last week';
                            } else {
                              headerText =
                                  '${DateFormat('MMM dd').format(e.last)} - ${DateFormat('MMM dd').format(e.first)}';
                            }

                            return SliverStickyHeader(
                              header: WeekHeaderWidget(text: headerText),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final day = e[index];

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 179, 171, 171),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          WeekTileLeading(
                                            day: day.day == DateTime.now().day
                                                ? 'Today'
                                                : DateFormat('EEE').format(day),
                                            number:
                                                DateFormat('dd').format(day),
                                            isToday: day.isToday(),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: Builder(builder: (context) {
                                              final mapKey =
                                                  DateFormat('MM/dd/yy')
                                                      .format(day);
                                              final entries =
                                                  _timelineData[mapKey];

                                              var stressScore =
                                                  '—% Stress score';

                                              if (entries?.isNotEmpty ??
                                                  false) {
                                                final moodList = <int>[];
                                                for (final element
                                                    in entries!) {
                                                  moodList.add(element['mood']);
                                                }
                                                final average =
                                                    moodList.average;
                                                stressScore =
                                                    '${(average * 20).round()}% Stress score';
                                              }

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stressScore,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Builder(
                                                    builder: (context) {
                                                      return SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children:
                                                              List.generate(
                                                            entries?.length ??
                                                                0,
                                                            (index) {
                                                              final data =
                                                                  entries![
                                                                      index];
                                                              var idx = 1;
                                                              switch (data[
                                                                  'mood']) {
                                                                case 5:
                                                                  idx = 1;
                                                                  break;
                                                                case 4:
                                                                  idx = 2;
                                                                  break;
                                                                case 3:
                                                                  idx = 3;
                                                                  break;
                                                                case 2:
                                                                  idx = 4;
                                                                  break;
                                                                case 1:
                                                                  idx = 5;
                                                                  break;
                                                                default:
                                                              }

                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            16),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/faces_$idx.png',
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 18),
                                          WeekTileContinueButton(
                                            isToday: day.isToday(),
                                          ),
                                        ],
                                      ),
                                      // title: Text('List tile #$i'),
                                    );
                                  },
                                  childCount: e.length,
                                ),
                              ),
                            );
                          },
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
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
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

    if (day.isAfter(DateTime.now()) && !day.isToday()) {
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
