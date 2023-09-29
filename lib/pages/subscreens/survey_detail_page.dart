// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SurveyDetailPage extends StatefulWidget {
  const SurveyDetailPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  PageController controller = PageController(initialPage: 0);
  PageController subController = PageController(initialPage: 0);
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * (60 * 5);

  int currentPage = 0;
  int subCurrentPage = 0;

  void _handleBackKey() {
    if (currentPage == 0) {
      Navigator.pop(context);
    } else if (currentPage == 2) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        subCurrentPage = 0;
      });
    } else {
      if (subCurrentPage == 0) {
        controller.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        subController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        currentPage = controller.page!.toInt();
      });
    });
    subController.addListener(() {
      setState(() {
        subCurrentPage = subController.page!.toInt();
      });
    });
  }

  void _handleNextKey() {
    switch (currentPage) {
      case 0:
        controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 2:
        Navigator.pop(context);
        break;
      default:
        if (subCurrentPage == 5) {
          controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          subController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
    }
  }

  String _buildPageTextButton() {
    switch (currentPage) {
      case 0:
        return 'Start Survey';
      case 2:
        return 'Complete Survey';
      default:
        if (subCurrentPage == 5) {
          return 'Submit survey';
        }
        return 'Next question';
    }
  }

  final List<String> items = [
    'Social media advertising',
    'Content marketing',
    'Influencer marketing',
  ];
  String selectedValue = 'Social media advertising';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _handleBackKey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xffEBEBEB),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Customer Satisfaction: A Survey of Gaming',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/notification.png',
                          height: 150,
                          width: 150,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Just a friendly reminder\nbefore starting our survey!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '''Your opinions are valuable to us, and we'd love to hear what you have to say.''',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: Color(0xff787878),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Survey',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: (subCurrentPage + 1).toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: ' of 6',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff6F6F6F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffEBEBEB),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(children: [
                                const Icon(
                                  FontAwesomeIcons.solidClock,
                                  color: Color(0xff818CF8),
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                CountdownTimer(
                                  endTime: endTime,
                                  widgetBuilder: (context, time) {
                                    if (time == null) {
                                      return const Center(
                                        child: Text(
                                          'Time is up, please complete the survey',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                          ),
                                        ),
                                      );
                                    }
                                    String value = '';
                                    if (time.days != null) {
                                      var days = _getNumberAddZero(time.days!);
                                      value = '$value$days days ';
                                    }
                                    final parsedHours = time.hours ?? 0;
                                    if (parsedHours > 0) {
                                      var hours =
                                          _getNumberAddZero(parsedHours);
                                      value = '$value$hours:';
                                    }
                                    var min = _getNumberAddZero(time.min ?? 0);
                                    value = '$value$min:';
                                    var sec = _getNumberAddZero(time.sec ?? 0);
                                    value = '$value$sec';
                                    return Text(
                                      value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                  onEnd: () {},
                                ),
                              ]),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: (subCurrentPage + 1) / 6,
                            ),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                              value: value,
                              color: const Color(0xff4F46E5),
                              backgroundColor: const Color(0xffD9D9D9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: subController,
                            children: [
                              SurveyQuestionDetail(
                                'What suggestions do you have to improve the event in the future?',
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 24,
                                  decoration: InputDecoration(
                                    hintText: 'Open-ended text response',
                                    hintStyle: const TextStyle(
                                      color: Color(0xffDBDBDB),
                                    ),
                                    focusColor: const Color(0xff4F46E5),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xff4F46E5),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffF4F4F4),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffF4F4F4),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              SurveyQuestionDetail(
                                'How satisfied are you with our services?',
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    var emoji = '';
                                    var title = '';
                                    final isSelected = index == 0;

                                    switch (index) {
                                      case 0:
                                        emoji = '🚀';
                                        title = 'Very Satisfied';
                                        break;
                                      case 1:
                                        emoji = '😊';
                                        title = 'Satisfied';
                                        break;
                                      case 2:
                                        emoji = '😐';
                                        title = 'Neutral';
                                        break;
                                      case 3:
                                        emoji = '😞';
                                        title = 'Unsatisfied';
                                        break;
                                      default:
                                    }

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xff4F46E5)
                                              : const Color(0xffF4F4F4),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Text(
                                          emoji,
                                          style: const TextStyle(
                                            color: Color(0xff818CF8),
                                            fontSize: 32,
                                          ),
                                        ),
                                        title: Text(
                                          title,
                                          style: TextStyle(
                                            color: isSelected
                                                ? const Color(0xff4F46E5)
                                                : Colors.black,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : null,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 16);
                                  },
                                  itemCount: 4,
                                ),
                              ),
                              SurveyQuestionDetail(
                                'What were the main challenges you faced while starting the company?',
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    var title = '';
                                    final isSelected = index == 1 || index == 2;

                                    switch (index) {
                                      case 0:
                                        title =
                                            'Difficulty finding the right team';
                                        break;
                                      case 1:
                                        title = 'Lack of funding';
                                        break;
                                      case 2:
                                        title = 'Competition in the market';
                                        break;
                                      case 3:
                                        title = 'Other (please specify)';
                                        break;
                                      default:
                                    }

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xff4F46E5)
                                              : const Color(0xffF4F4F4),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          title,
                                          style: TextStyle(
                                            color: isSelected
                                                ? const Color(0xff4F46E5)
                                                : Colors.black,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : null,
                                          ),
                                        ),
                                        trailing: Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: const Color(0xff4F46E5),
                                          //     MaterialStateProperty.resolveWith(
                                          //   (_) => const Color(0xff4F46E5),
                                          // ),
                                          value: isSelected,
                                          shape: const CircleBorder(),
                                          onChanged: (bool? value) {},
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 16);
                                  },
                                  itemCount: 4,
                                ),
                              ),
                              SurveyQuestionDetail(
                                'Can you discuss your marketing strategies and how you attract new customers?',
                                shouldWrapChildInExpanded: false,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 25,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      hint: Text(
                                        'Please choose an option',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      items: items
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedValue,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedValue = value as String;
                                        });
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        height: 40,
                                        width: 140,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SurveyQuestionDetail(
                                'What is the average workday start and end time for your team?',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Start time:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(17),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffF4F4F4),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.clock,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            '08:00 AM',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            CupertinoIcons.arrow_down,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'End time:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(17),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffF4F4F4),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.clock,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            '05:00 PM',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            CupertinoIcons.arrow_down,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SurveyQuestionDetail(
                                'How do you differentiate yourself from your competitors?',
                                child: SizedBox.expand(
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(4),
                                    padding: const EdgeInsets.all(6),
                                    strokeWidth: 1,
                                    dashPattern: const <double>[
                                      8,
                                    ],
                                    strokeCap: StrokeCap.round,
                                    color: const Color(0xff4F46E5),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffEEEEFF),
                                              border: Border.all(
                                                color: const Color(0xff6366F1),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Upload',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Color(0xff4F46E5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Attach files up to 5 MB',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(
                                                0xffCBD5E1,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Only .pdf, .jpeg, .jpg, .png files are supported.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(
                                                0xffCBD5E1,
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
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/success.png',
                          height: 150,
                          width: 150,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'We\'re all done!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '''Thank you for taking the time to complete our survey. ''',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: Color(0xff787878),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _handleNextKey();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff6366F1),
                    borderRadius: BorderRadius.circular(31),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      _buildPageTextButton(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getNumberAddZero(int number) {
    if (number < 10) {
      return "0$number";
    }
    return number.toString();
  }
}

class SurveyQuestionDetail extends StatelessWidget {
  final String title;
  final Widget child;
  final bool shouldWrapChildInExpanded;

  const SurveyQuestionDetail(
    this.title, {
    super.key,
    required this.child,
    this.shouldWrapChildInExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyQuestionHeaderWidget(
          title,
        ),
        const SizedBox(height: 12),
        if (shouldWrapChildInExpanded)
          Expanded(
            child: child,
          )
        else
          child,
      ],
    );
  }
}

class SurveyQuestionHeaderWidget extends StatelessWidget {
  final String name;

  const SurveyQuestionHeaderWidget(
    this.name, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }
}
