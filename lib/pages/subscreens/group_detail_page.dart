import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:impak_mobile/pages/widgets/list_view_fragment.dart';

class GroupDetailPage extends StatelessWidget {
  final bool isGroup;
  final Map data;

  const GroupDetailPage({
    super.key,
    required this.isGroup,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    Map? leader;
    List<Map> members = [];
    for (final member in (data['members'] as List)) {
      if (member['pivot']['is_leader'] == 1) {
        leader = member;
      } else {
        members.add(member);
      }
    }

    return ListViewFragment(
      name: 'Members',
      hasBack: true,
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffEBEBEB),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_outlined,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data['members'].length} Members',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Builder(builder: (context) {
                  if (leader != null) {
                    return GroupTopMemberDetailWidget(
                      isGroup: isGroup,
                      name: leader['name'],
                      color: const Color(0xff6366F1),
                      position: isGroup ? 'Group leader' : 'Department head',
                    );
                  }

                  return const SizedBox();
                }),
                const SizedBox(height: 15),
                // if (!isGroup) ...[
                //   const Text(
                //     'Top-performing Members',
                //     style: TextStyle(
                //       fontWeight: FontWeight.w500,
                //       fontSize: 16,
                //     ),
                //   ),
                //   const SizedBox(height: 15),
                //   GroupTopMemberDetailWidget(
                //     isGroup: isGroup,
                //     name: 'Oliver Michael',
                //     color: const Color(0xff6366F1),
                //     position: 'Champion',
                //   ),
                //   const SizedBox(height: 15),
                //   GroupTopMemberDetailWidget(
                //     isGroup: isGroup,
                //     name: 'William Joseph',
                //     color: const Color(0xff818CF8),
                //     position: 'Top 1',
                //   ),
                //   const SizedBox(height: 15),
                //   GroupTopMemberDetailWidget(
                //     isGroup: isGroup,
                //     name: 'Noah Alexander',
                //     color: const Color(0xffA5B4FC),
                //     position: 'Top 2',
                //   ),
                //   const SizedBox(height: 15),
                // ],
                if (members.isNotEmpty) ...[
                  const Text(
                    'Members',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      final member = members[index];

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 1250),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: NormalMemberWidget(
                              name: member['name'],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                    itemCount: members.length,
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NormalMemberWidget extends StatelessWidget {
  const NormalMemberWidget({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffEBEBEB),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: double.infinity,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://ui-avatars.com/api/?name=$name',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
              ),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: '${Random().nextInt(500) + 10}+',
              //         style: const TextStyle(
              //           color: Color(0xff6366F1),
              //           fontWeight: FontWeight.bold,
              //           fontSize: 12,
              //         ),
              //         children: const [
              //           TextSpan(
              //             text: ' points',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w400,
              //               fontSize: 12,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          // const Spacer(),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Align(
          //       alignment: Alignment.center,
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: const Color(0xffC7D2FE),
          //           borderRadius: BorderRadius.circular(40),
          //         ),
          //         padding: const EdgeInsets.symmetric(
          //           vertical: 2,
          //           horizontal: 8,
          //         ),
          //         child: Center(
          //           child: Row(
          //             children: const [
          //               Text(
          //                 '23',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 12,
          //                 ),
          //               ),
          //               SizedBox(width: 4),
          //               Icon(
          //                 Icons.arrow_upward,
          //                 size: 14,
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class GroupTopMemberDetailWidget extends StatelessWidget {
  final String name;
  final Color color;

  const GroupTopMemberDetailWidget({
    super.key,
    required this.isGroup,
    required this.name,
    required this.color,
    required this.position,
  });

  final bool isGroup;
  final String position;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: double.infinity,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  'https://ui-avatars.com/api/?name=$name',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
              ),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: '${Random().nextInt(500) + 10}+',
              //         style: const TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 12,
              //         ),
              //         children: const [
              //           TextSpan(
              //             text: ' points',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.w400,
              //               fontSize: 12,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Expanded(
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         color: const Color(0xffC7D2FE),
              //         borderRadius: BorderRadius.circular(40),
              //       ),
              //       padding: const EdgeInsets.symmetric(
              //         vertical: 2,
              //         horizontal: 8,
              //       ),
              //       child: Center(
              //         child: Row(
              //           children: const [
              //             Text(
              //               '23',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 12,
              //               ),
              //             ),
              //             SizedBox(width: 4),
              //             Icon(
              //               Icons.arrow_upward,
              //               size: 14,
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    position,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
