import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_shorts/constants.dart';

class ViewReplies extends StatelessWidget {
  const ViewReplies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 200,
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Column(
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(logo),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [Text("name"), Text("proshorts")],
                    )
                  ],
                ),
                const Text("this is your reply"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.thumb_up)),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.thumb_down)),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.send))),
                                    autofocus: true,
                                  ),
                                );
                              });
                        },
                        child: const Text("Reply")),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
