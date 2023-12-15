import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impak_mobile/chopper/api_service.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  int selected = 5;
  final _controller = TextEditingController();

  final colors = const [
    Color(0xffA18FFF),
    Color(0xffFE814B),
    Color(0xff926247),
    Color.fromARGB(255, 248, 193, 64),
    Color(0xff9BB068),
  ];

  Widget get getFaceDescriptor {
    var list = ['depressed', 'sad', 'neutral', 'happy', 'overjoyed'];

    return SizedBox(
      child: SvgPicture.asset(
        'assets/${list[selected - 1]}.svg',
        height: 200,
      ),
    );
  }

  String get getMoodDescriptorStart {
    switch (selected) {
      case 1:
        return 'I am feeling';
      case 2:
        return 'I am feeling';
      case 3:
      case 4:
        return 'I feel';
      case 5:
        return 'I am';
      default:
        return 'I feel';
    }
  }

  String get getMoodDescriptorBold {
    switch (selected) {
      case 1:
        return 'very sad';
      case 2:
        return 'sad';
      case 3:
        return 'neutral';
      case 4:
        return 'happy';
      case 5:
        return 'very happy';
      default:
        return 'neutral';
    }
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
              color: colors[selected - 1],
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'How are you feeling?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Users typically log their moods at regular intervals, such as daily or weekly, using a variety of emotional descriptors.',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            getFaceDescriptor,
                            SizedBox(
                              child: RatingBar.builder(
                                initialRating: selected.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
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
                                    selected = rating.toInt();
                                  });
                                },
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: '$getMoodDescriptorStart ',
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: getMoodDescriptorBold,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      Builder(builder: (context) {
                        final borderRadius = BorderRadius.circular(24);
                        final border = OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 138, 157, 94),
                            width: 3,
                          ),
                        );

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 149, 164, 113)
                                    .withOpacity(0.5),
                                spreadRadius: 3,
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: border,
                              enabledBorder: border,
                              hintText: 'Record a short snippet of your day!',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.multiline,
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          final invert = 5 - selected + 1;

                          final validate = await GetIt.instance
                              .get<ChopperClient>()
                              .getService<ApiService>()
                              .submitMood({
                            'mood': invert,
                            'journal': _controller.text,
                          });

                          if (validate.isSuccessful && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xff6366F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Log my reflection'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
          ),
        ],
      ),
    );
  }
}
