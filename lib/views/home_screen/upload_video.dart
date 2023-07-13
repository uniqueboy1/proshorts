import 'package:flutter/material.dart';
import 'package:pro_shorts/views/widgets/home_screen/video_details_input.dart';

List videoCategory = [
  "Select Category",
  "Web Development",
  "App Development",
  "Machine Learning",
  "Artificial Intelligence",
  "Programming News",
  "Other"
];

List videoMode = ["Select Video Mode", "Public", "Private"];

class UploadVideo extends StatefulWidget {
  UploadVideo({Key? key}) : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();

  String selectedCategory = videoCategory.first;
  String selectedMode = videoMode.first;
  List keywords = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Video details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                VideoDetailsInput(
                  controller: titleController,
                  labelText: "Enter title of the video",
                  prefixIcon: Icons.title,
                  emptyMessage: "PLease enter title",
                ),
                SizedBox(
                  height: 15,
                ),
                VideoDetailsInput(
                  controller: titleController,
                  labelText: "Enter description of the video",
                  prefixIcon: Icons.description,
                  emptyMessage: "PLease enter description",
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: keywordsController,
                  onChanged: (value) {
                    if (value.contains(".")) {
                      keywordsController.clear();
                      keywords.add(value.replaceFirst(".", ""));
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Enter some keywords",
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter keywords";
                    }
                    return null;
                  },
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 0, minWidth: size.width * 0.5),
                    child: Container(
                        child: Column(
                          children: keywords.map((keyword) {
                            return Chip(
                              label: Text(keyword),
                            );
                          }).toList(),
                        ))),
                SizedBox(
                  height: 15,
                ),
                DropdownButton(
                    isExpanded: true,
                    value: selectedCategory,
                    items: videoCategory.map((category) {
                      return DropdownMenuItem<String>(
                          enabled: category == videoCategory[0] ? false : true,
                          value: category,
                          child: Text(category));
                    }).toList(),
                    onChanged: (String? value) {
                      selectedCategory = value!;
                      setState(() {});
                    }),
                SizedBox(
                  height: 15,
                ),
                DropdownButton(
                    isExpanded: true,
                    value: selectedMode,
                    items: videoMode.map((mode) {
                      return DropdownMenuItem<String>(
                          enabled: mode == videoMode[0] ? false : true,
                          value: mode,
                          child: Text(mode));
                    }).toList(),
                    onChanged: (String? value) {
                      selectedMode = value!;
                      setState(() {});
                    }),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: Text("Save as Draft")),
                    ElevatedButton(onPressed: () {}, child: Text("Upload"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
