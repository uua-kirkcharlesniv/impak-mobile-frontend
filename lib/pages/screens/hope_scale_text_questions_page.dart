import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/pages/screens/recommendations_page.dart';

class HopeScaleTextQuestionsPage extends StatefulWidget {
  const HopeScaleTextQuestionsPage({super.key});

  @override
  State<HopeScaleTextQuestionsPage> createState() =>
      _HopeScaleTextQuestionsPageState();
}

class _HopeScaleTextQuestionsPageState
    extends State<HopeScaleTextQuestionsPage> {
  int currentPage = 0;

  final questions = [
    "What could your organization do to improve your mood?",
    "Is there anything else you would like to share about your mood today?",
    "What were you doing immediately before taking this survey?",
  ];

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
            child: SizedBox.expand(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(29.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[currentPage],
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your answer will be submitted anonymously.',
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          expands: true,
                          minLines: null,
                          maxLines: null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if ((currentPage + 1) == questions.length) {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RecommendationsPage();
                                  },
                                ),
                              );
                              return;
                            }

                            setState(() {
                              currentPage += 1;
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
                            color: const Color(0xff6366F1),
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
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
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
