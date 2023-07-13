import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/get/home_screen/get_make_notes.dart';

class MakeNotes extends StatelessWidget {
  MakeNotes({Key? key}) : super(key: key);
  TextEditingController noteController = TextEditingController();
  MakeNotesController makeNotesController = Get.put(MakeNotesController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Make Notes"),
        ),
        body: Center(
          child: SizedBox(
            width: size.width * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                    controller: noteController,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      makeNotesController.notes.add(noteController.text);
                      noteController.clear();
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Write bullet points"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter some points";
                      }
                      return null;
                    },
                    ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Obx(
                  () => ListView.builder(
                      itemCount: makeNotesController.notes.length,
                      itemBuilder: (context, index) {
                        String note = makeNotesController.notes[index];
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Text("${index + 1}."),
                                title: Text(
                                  "$note",
                                  style: TextStyle(height: 1.5),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        makeNotesController.editNote(
                                            index, noteController);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        makeNotesController.deleteNote(index);
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                )),
                Obx(() => makeNotesController.notes.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          makeNotesController.saveTextFile();

                        }, child: Text("Save Text File"))
                    : SizedBox())
              ],
            ),
          ),
        ));
  }
}
