import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/models/note_model.dart';
import 'package:jayx_keep/models/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstrucot();
  static final DatabaseHelper instance = DatabaseHelper._privateConstrucot();

  late Database _database;

  Future<void> initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, kDatabaseName);

    _database = await openDatabase(path, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute(
          '''CREATE TABLE $kTableNotes ($kColumnId STRING PRIMARY KEY, $kColumnTitle TEXT, $kColumnContent TEXT NOT NULL, $kColumnLabel INTEGER NOT NULL)''');
    });
  }

  Future<NotesModel> getAllNotes() async {
    List<Map> maps = await _database.query(kTableNotes);
    NotesModel notes = NotesModel();

    for (var element in maps) {
      notes.saveNote(NoteModel(
          id: element[kColumnId],
          noteTitle: element[kColumnTitle],
          noteContent: element[kColumnContent],
          noteLable: element[kColumnLabel]));
    }
    print('Notes in database: $maps');
    return notes;
  }

  Future<void> insert(NoteModel note) async {
    await _database.insert(kTableNotes, note.toMap());
  }

  Future<void> update(NoteModel note) async {
    await _database.update(kTableNotes, note.toMap(),
        where: '$kColumnId = ?', whereArgs: [note.id]);
  }

  Future<void> delete(NoteModel note) async {
    await _database
        .delete(kTableNotes, where: '$kColumnId = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNoteDatabase() async {
    // Remove the database and all the entries
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, kDatabaseName);

    await deleteDatabase(path);
  }
}
