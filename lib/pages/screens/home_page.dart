import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:impak_mobile/pages/widgets/mood_week_indicator_widget.dart';

import '../widgets/homepage_survey_entry_widget.dart';
import '../widgets/mood_entry_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: SafeArea(
              top: true,
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(29),
                  child: AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 375),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Good morning,'),
                                  Text(
                                    'John Doe',
                                    style: TextStyle(
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
                                child: const CircleAvatar(
                                  radius: 22.5,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 21.5,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        'https://api.dicebear.com/6.x/pixel-art/png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const HomepageSurveyWidget(
                            color: Color(0xff6EE7B7),
                            name: "Dragon's Fury: The\nAdventurer's Opinion",
                          ),
                          const SizedBox(height: 15),
                          const HomepageSurveyWidget(
                            color: Color(0xffFCD34D),
                            name:
                                "The Dragon's Realm: A\nSurvey of Gaming\nPreferences",
                          ),
                          const SizedBox(height: 15),
                          Center(child: const MoodWeekIndicator()),
                          const SizedBox(height: 15),
                          const Text(
                            'My Journal',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const MoodEntryWidget(),
                          const SizedBox(height: 15),
                          const MoodEntryWidget(),
                          const SizedBox(height: 15),
                          const MoodEntryWidget(),
                          const SizedBox(height: 15),
                          const MoodEntryWidget(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
