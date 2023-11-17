import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/survey_list_widget.dart';

class SurveyListGridItem extends StatelessWidget {
  const SurveyListGridItem({
    super.key,
    this.data,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xffEAEAEA),
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 90,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      data['photo'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1.5,
                        ),
                        child: AutoSizeText(
                          data['survey_type']
                              .toString()
                              .replaceAll('_', ' ')
                              .toTitleCase(),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(
                CupertinoIcons.clock_fill,
                color: Colors.grey,
                size: 12,
              ),
              SizedBox(width: 2.5),
              Text(
                '9 PM, Today',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xff0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            data['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff0F172A),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Text(
            data['rationale_description'],
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: Color(0xff696969),
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          const Spacer(),
          Builder(builder: (context) {
            if (data['is_open'] != true) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.33),
                      blurRadius: 13,
                      offset: const Offset(0, 4),
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.red.shade400,
                      Colors.red.shade800,
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Closed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff544BE8).withOpacity(0.33),
                    blurRadius: 13,
                    offset: const Offset(0, 4),
                  )
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff7C74FF),
                    Color(0xff544BE8),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Start Survey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
