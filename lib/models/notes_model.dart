import 'package:jayx_keep/models/note_model.dart';

class NotesModel {
  final List<NoteModel> _notes = [];

  int get notesCout => _notes.length;

  NoteModel getNote(int index) {
    return _notes[index];
  }

  void deleteNote({required NoteModel note}) {
    NoteModel toRemove = _notes.firstWhere((element) => element.id == note.id);
    _notes.remove(toRemove);
  }

  void saveNote(NoteModel note, [int? editIndex]) {
    if (editIndex != null) {
      _notes[editIndex].noteTitle = note.noteTitle;
      _notes[editIndex].noteContent = note.noteContent;
      _notes[editIndex].noteLable = note.noteLable;
      print('saveNote: ${_notes.indexOf(note)}');
    } else {
      _notes.add(note);
      print('saveNote: ${_notes.indexOf(note)}');
    }
  }

  List<int> searchNotes(String searchQuery) {
    List<int> relevantindexes = [];
    _notes.asMap().forEach((index, note) {
      if (note.noteTitle != null) {
        if (note.noteTitle!.contains(searchQuery) ||
            note.noteContent.contains(searchQuery)) {
          relevantindexes.add(index);
          print(relevantindexes);
        }
      }
    });
    return relevantindexes;
  }
}
