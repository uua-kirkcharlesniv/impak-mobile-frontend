import 'package:flutter/material.dart';
import 'package:impak_mobile/pages/subscreens/group_detail_page.dart';

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({
    super.key,
    required this.isFirst,
    required this.index,
    this.isGroup = true,
    required this.data,
  });

  final bool isFirst;
  final bool isGroup;
  final int index;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GroupDetailPage(
              isGroup: isGroup,
              data: data,
            ),
          ),
        );
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: isFirst ? const Color(0xff6366F1) : Colors.white,
          borderRadius: BorderRadius.circular(2),
          border: isFirst
              ? null
              : Border.all(
                  color: const Color(0xffE2E8F0),
                ),
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
                    Uri.encodeFull(
                        'https://ui-avatars.com/api/?name=test&format=png'),
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
                  data['name'].toString(),
                  style: TextStyle(
                    color: isFirst ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
                // Text(
                //   'Description',
                //   style: TextStyle(
                //     color: isFirst ? Colors.white : const Color(0xff94A3B8),
                //     fontWeight: FontWeight.w400,
                //     fontSize: 12,
                //   ),
                //   maxLines: 1,
                // ),
              ],
            ),
            // const Spacer(),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Expanded(
            //       child: index > 5
            //           ? Text(
            //               'New member',
            //               style: TextStyle(
            //                 color: isFirst
            //                     ? Colors.white
            //                     : const Color(0xff94A3B8),
            //                 fontSize: 12,
            //               ),
            //             )
            //           : const SizedBox(),
            //     ),
            //     Expanded(
            //       child: Align(
            //         alignment: Alignment.bottomRight,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: const Color(0xffC7D2FE),
            //             borderRadius: BorderRadius.circular(40),
            //           ),
            //           padding: const EdgeInsets.symmetric(
            //             vertical: 2,
            //             horizontal: 8,
            //           ),
            //           child: const Center(
            //             child: Text(
            //               '23',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 12,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
