import 'package:flutter/material.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    final faces = [
      {
        'image': 'assets/faces_2.png',
        'name': 'Very calm',
      },
      {
        'image': 'assets/faces_4.png',
        'name': 'Calm',
      },
      {
        'image': 'assets/faces_3.png',
        'name': 'Neutral',
      },
      {
        'image': 'assets/faces_5.png',
        'name': 'Stressed',
      },
      {
        'image': 'assets/faces_1.png',
        'name': 'Very stressed',
      },
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
              child: Padding(
                padding: const EdgeInsets.all(29),
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffE2E2F5),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'How are you feeling?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Users typically log their moods at regular intervals, such as daily or weekly, using a variety of emotional descriptors.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xff525969),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    faces[index]['image'].toString(),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    faces[index]['name'].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(
                                        selected == index ? 4 : 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xffDDDDDD),
                                      ),
                                      color: selected == index
                                          ? const Color(0xff4F46E5)
                                          : null,
                                    ),
                                    child: selected == index
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 12,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        if (selected != null) {
                          Navigator.pop(context);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: selected != null
                              ? const Color(0xff6366F1)
                              : const Color(0xffEAEAF9),
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
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
