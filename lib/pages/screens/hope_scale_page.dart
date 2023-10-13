import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/pages/screens/hope_scale_text_questions_page.dart';
import 'package:impak_mobile/pages/screens/recommendations_page.dart';

class HopeScalePage extends StatefulWidget {
  const HopeScalePage({super.key});

  @override
  State<HopeScalePage> createState() => _HopeScalePageState();
}

class _HopeScalePageState extends State<HopeScalePage> {
  int selectedAnswer = 5;
  int currentPage = 0;

  final colors = const [
    Color(0xffA18FFF),
    Color(0xffFE814B),
    Color(0xff926247),
    Color.fromARGB(255, 248, 193, 64),
    Color(0xff9BB068),
  ];

  final startDescriptor = [
    "I am feeling",
    "I am feeling",
    "I am",
    "I was",
    "I am feeling",
    "I am feeling",
    "I am feeling",
    "I am feeling",
    "I am feeling",
    "I would rate it",
  ];

  final questions = [
    "How would you rate your overall mood today?",
    "How much energy do you have today?",
    "How would you rate your concentration levels today?",
    "How productive have you been today?",
    "How stressed are you feeling today?",
    "How happy are you today?",
    "How connected do you feel to your colleagues today?",
    "How supported do you feel by your manager today?",
    "How satisfied are you with your work today?",
    "How would you rate your overall sense of well-being today?",
  ];

  final mainDescriptors = <(String, String, String, String, String)>[
    ("Very Bad", "Bad", "Neutral", "Good", "Very Good"),
    ("Very Tired", "Tired", "Neutral", "Energized", "Super Energized"),
    ("Very Distracted", "Distracted", "Neutral", "Focused", "Very Focused"),
    (
      "Very Unproductive",
      "Unproductive",
      "Neutral",
      "Productive",
      "Very Productive"
    ),
    (
      "Highly Stressed",
      "Stressed",
      "Neutral",
      "Slight Stress",
      "Not stressed at all"
    ),
    ("Very Unhappy", "Unhappy", "Neutral", "Happy", "Very Happy"),
    (
      "Very Disconnected",
      "Disconnected",
      "Neutral",
      "Connected",
      "Very Connected"
    ),
    (
      "Very Unsupported",
      "Unsupported",
      "Neutral",
      "Supported",
      "Very Supported"
    ),
    (
      "Very Dissatisfied",
      "Dissatisfied",
      "Neutral",
      "Satisfied",
      "Very Satisfied"
    ),
    ("Very Low", "Low", "Neutral", "High", "Very High"),
  ];

  String get mainDescriptorParsed {
    switch (selectedAnswer) {
      case 0:
      case 1:
      case 2:
        return mainDescriptors[currentPage].$1;
      case 3:
      case 4:
        return mainDescriptors[currentPage].$2;
      case 5:
      case 6:
        return mainDescriptors[currentPage].$3;
      case 7:
      case 8:
        return mainDescriptors[currentPage].$4;
      case 9:
      case 10:
        return mainDescriptors[currentPage].$5;
    }

    return mainDescriptors[currentPage].$3;
  }

  Color get currentColor {
    switch (selectedAnswer) {
      case 0:
      case 1:
      case 2:
        return colors[0];
      case 3:
      case 4:
        return colors[1];
      case 5:
      case 6:
        return colors[2];
      case 7:
      case 8:
        return colors[3];
      case 9:
      case 10:
        return colors[4];
    }

    return colors[2];
  }

  Widget get getFaceDescriptor {
    var assetName = '';

    switch (selectedAnswer) {
      case 0:
      case 1:
      case 2:
        assetName = 'depressed.svg';
      case 3:
      case 4:
        assetName = 'sad.svg';
      case 5:
      case 6:
        assetName = 'neutral.svg';
      case 7:
      case 8:
        assetName = 'happy.svg';
      case 9:
      case 10:
        assetName = 'overjoyed.svg';
    }

    assetName = 'assets/$assetName';

    return SizedBox(
      child: SvgPicture.asset(
        assetName,
        height: 200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              duration: const Duration(milliseconds: 300),
              color: currentColor,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Text(
                        questions[currentPage],
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 64),
                      getFaceDescriptor,
                      const SizedBox(height: 64),
                      SizedBox(
                        key: ValueKey(currentPage),
                        child: RatingBar.builder(
                          initialRating: selectedAnswer.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 10,
                          itemBuilder: (context, _) => Icon(
                            Icons.favorite,
                            color: Colors.white.withOpacity(0.85),
                            size: 10,
                          ),
                          glowColor: Colors.white,
                          glow: false,
                          itemSize: 32,
                          updateOnDrag: true,
                          onRatingUpdate: (rating) {
                            setState(() {
                              selectedAnswer = rating.toInt();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 64),
                      RichText(
                        text: TextSpan(
                            text: '${startDescriptor[currentPage]} ',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                            children: [
                              TextSpan(
                                text: mainDescriptorParsed.toLowerCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ]),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if ((currentPage + 1) == 10) {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const HopeScaleTextQuestionsPage();
                                  },
                                ),
                              );
                              return;
                            }

                            setState(() {
                              currentPage += 1;
                              selectedAnswer = 5;
                            });
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          margin: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              32,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.green,
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
