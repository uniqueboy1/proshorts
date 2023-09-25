import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class MakeNotesController extends GetxController {
  RxList notes = [].obs;

  void editNote(int index, TextEditingController noteController) {
    noteController.text = notes[index];
    // moving cursor after text
    noteController.selection =
        TextSelection.fromPosition(TextPosition(offset: notes[index].length));
    notes.removeAt(index);
  }

  void deleteNote(int index) {
    notes.removeAt(index);
  }

  void saveTextFile() async{
    Directory folder = await getApplicationDocumentsDirectory();
    await Directory("proshorts").create(recursive: true);
    File file = File("${folder.path}/notes.txt");
    await file.writeAsString(notes.join(""));
    print("file");
    print(file);

  }

  
  
}
