import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:impak_mobile/blocs/survey/bloc/survey_bloc.dart';

import '../subscreens/survey_detail_page.dart';

class SurveyListWidget extends StatelessWidget {
  const SurveyListWidget({
    super.key,
    required this.isFirst,
    required this.data,
    this.isCompleted = false,
  });

  final bool isFirst;
  final bool isCompleted;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xffEBEBEB),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 48),
                          child: Text(
                            data['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data['survey_type']
                              .toString()
                              .replaceAll('_', ' ')
                              .toTitleCase(),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffE9E9E9).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Builder(builder: (context) {
                            final descriptor = isCompleted
                                ? 'Last answered at '
                                : 'Deadline: ';

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (isCompleted)
                                  const Icon(
                                    FontAwesomeIcons.check,
                                    color: Colors.green,
                                    size: 10,
                                  )
                                else
                                  const Icon(
                                    FontAwesomeIcons.solidClock,
                                    color: Color(0xff818CF8),
                                    size: 10,
                                  ),
                                const SizedBox(width: 4),
                                RichText(
                                  text: TextSpan(
                                    text: descriptor,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Today 8 PM',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  if (!isCompleted)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => SurveyBloc(),
                              child: SurveyDetailPage(
                                id: data['id'],
                                name: data['name'],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFirst ? const Color(0xff6366F1) : null,
                          border: isFirst
                              ? null
                              : Border.all(
                                  color: const Color(0xff6366F1),
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(top: 48),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: isFirst
                                    ? Colors.white
                                    : const Color(0xff6366F1),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 12,
                              color: isFirst
                                  ? Colors.white
                                  : const Color(0xff6366F1),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isCompleted)
            Positioned(
              right: 20,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                      color: const Color(0xffEBEBEB),
                    )),
                child: Column(
                  children: [
                    const Text(
                      'Time Limit',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.timer,
                          size: 12,
                          color: Color(0xff6366F1),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '5 min',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xff6366F1),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
