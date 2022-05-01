import 'package:uuid/uuid.dart';
import 'package:jayx_keep/constants.dart';

class NoteModel {
  late String id;
  String? noteTitle;
  String noteContent;
  int noteLable;

  NoteModel(
      {this.noteTitle,
      required this.noteContent,
      this.noteLable = 0,
      this.id = "0"}) {
    if (id == "0") {
      var uuid = const Uuid();
      id = uuid.v4();
    }
  }

  // DATABASE HELPERS
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      kColumnId: id,
      kColumnContent: noteContent,
      kColumnLabel: noteLable
    };

    if (noteTitle != null) {
      map[kColumnTitle] = noteTitle;
    }

    return map;
  }
}
