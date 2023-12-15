import 'package:auto_size_text/auto_size_text.dart';
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
    this.onFinish,
  });

  final bool isFirst;
  final bool isCompleted;
  final Map<String, dynamic> data;
  final VoidCallback? onFinish;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xffEBEBEB),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  data['photo'],
                  fit: BoxFit.cover,
                  height: 130,
                  width: double.infinity,
                ),
              ),
            ),
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
                            decoration: BoxDecoration(
                              color: const Color(0xff6366F1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1.5,
                            ),
                            child: Text(
                              data['survey_type']
                                  .toString()
                                  .replaceAll('_', ' ')
                                  .toTitleCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(right: 48),
                            child: Text(
                              data['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: AutoSizeText(
                                  data['rationale_description'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xff696969),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: SizedBox(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                                          text: data['last_entry_date']
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                          ).then((value) {
                            onFinish?.call();
                          });
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
                  child: const Column(
                    children: [
                      Text(
                        'Time Limit',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
