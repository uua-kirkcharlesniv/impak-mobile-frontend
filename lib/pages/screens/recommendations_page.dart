import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class Recommendation {
  final String imagePath;
  final String title;
  final String description;

  Recommendation({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendations = [
      Recommendation(
        imagePath: 'assets/workout.png',
        title: 'Get some exercise',
        description: 'Even a short walk can help to improve your mood!',
      ),
      Recommendation(
        imagePath: 'assets/family.png',
        title: 'Spend time with loved ones',
        description: 'Social interaction can help to lift your spirits',
      ),
      Recommendation(
        imagePath: 'assets/hobby.png',
        title: 'Do something you enjoy',
        description:
            'Whether it\'s reading, listening to music, or watching a movie, doing something you enjoy can help to take your mind off of your troubles.',
      ),
      Recommendation(
        imagePath: 'assets/converse.png',
        title: 'Talk to someone you trust',
        description:
            'Talking about how you\'re feeling can help you to feel better.',
      ),
    ];

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
            child: SizedBox.expand(
              child: OnBoardingSlider(
                totalPage: recommendations.length,
                headerBackgroundColor: Colors.transparent,
                controllerColor: const Color(0xff6366F1),
                background: recommendations
                    .map(
                      (e) => const SizedBox(),
                    )
                    .toList(),
                speed: 1.5,
                finishButtonText: 'Got it!',
                finishButtonTextStyle: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                finishButtonStyle: const FinishButtonStyle(
                  backgroundColor: Color(0xff6366F1),
                ),
                onFinish: () {
                  Navigator.pop(context);
                },
                pageBodies: recommendations
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(29.0),
                        child: Column(
                          children: [
                            Text(
                              'Your Personalized Recommendations',
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(64.0),
                              child: Image.asset(e.imagePath),
                            ),
                            Text(
                              e.title,
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              e.description,
                              style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
