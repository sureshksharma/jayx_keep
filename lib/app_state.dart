import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/database_helper/database_helper.dart';
import 'package:jayx_keep/models/note_model.dart';
import 'package:jayx_keep/models/notes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String userEmail = kDefaultEmail;
  late CollectionReference notesCollection;
  bool useSql = true;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  NotesModel notesModel = NotesModel();

  bool isDarkTheme = true;

  Future<void> initialization() async {
    await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(kThemeKeySharedPreferences) == null) {
      prefs.setBool(kThemeKeySharedPreferences, isDarkTheme);
    } else {
      isDarkTheme = prefs.getBool(kThemeKeySharedPreferences)!;
    }
    print('Dark Mode Preference: ${prefs.getBool(kThemeKeySharedPreferences)}');
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      userEmail = auth.currentUser!.email!;
      useSql = false;
    }
  }

  void setThemeBool(bool isUsingDarkTheme) async {
    this.isDarkTheme = isUsingDarkTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(kThemeKeySharedPreferences, isDarkTheme);
    notifyListeners();
  }

  void readNotes() {
    if (useSql) {
      _databaseHelper.initDatabase().then((value) {
        readNotesFromSqlite();
      });
    } else {
      readNotesFromFirestore();
    }
  }

  void readNotesFromSqlite() async {
    notesModel = await _databaseHelper.getAllNotes();
    notifyListeners();
  }

  void readNotesFromFirestore() async {
    notesCollection = FirebaseFirestore.instance.collection(userEmail);
    notesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        notesModel.saveNote(NoteModel(
            id: doc.id,
            noteTitle: doc['title'],
            noteContent: doc['content'],
            noteLable: doc['label']));
        notifyListeners();
      });
    });
  }

  void saveNote(NoteModel newNote, [int? index]) {
    this.notesModel.saveNote(newNote, index);

    if (index == null) {
      // Creating a note
      if (useSql) {
        _databaseHelper.insert(newNote);
      } else {
        notesCollection
            .doc(newNote.id)
            .set({
              'title': newNote.noteTitle,
              'content': newNote.noteContent,
              'label': newNote.noteLable
            })
            .then((value) => print("Note added in firestore!"))
            .catchError((error) =>
                print("There was an error while adding note: $error"));
      }
    } else {
      if (useSql) {
        _databaseHelper.update(newNote);
      } else {
        notesCollection
            .doc(newNote.id)
            .update({
              'title': newNote.noteTitle,
              'content': newNote.noteContent,
              'label': newNote.noteLable
            })
            .then((value) => print("Note added in firestore"))
            .catchError((error) =>
                print("There was an error while updating note: $error"));
      }
    }
    notifyListeners();
  }

  void deleteNote(NoteModel note) {
    this.notesModel.deleteNote(note: note);

    if (useSql) {
      _databaseHelper.delete(note);
    } else {
      notesCollection
          .doc(note.id)
          .delete()
          .then((value) => print("Note removed from firebase firestore"))
          .catchError((error) =>
              print("There was an error while deleting the note: $error"));
    }
    notifyListeners();
  }

  Future<kLoginCodesEnum> loginUser({String? email, String? password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // After user is created, the local database needs to be migrated to
      // Firestore and local files need to be cleaned.
      userEmail = email;
      useSql = false;

      migrateLocalDataToFirestore();
      notesModel =
          NotesModel(); // Creating new notes model as it will have fresh data from firestore.

      readNotes();
      return kLoginCodesEnum.successful;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return kLoginCodesEnum.weak_password;
      } else if (e.code == 'email-already-in-use') {
        // Account exists. Just login
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email!, password: password!);

          userEmail = email;
          useSql = false;

          migrateLocalDataToFirestore();
          notesModel =
              NotesModel(); // Creating new notes model as it will have fresh data from firestore.
          readNotes();
          return kLoginCodesEnum.successful;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            return kLoginCodesEnum.wrong_password;
          } else {
            print("Some issue while logging in");
            return kLoginCodesEnum.unknownError;
          }
        }
      } else {
        print("Some issue while registration");
        return kLoginCodesEnum.unknownError;
      }
    }
  }

  void migrateLocalDataToFirestore() {
    notesCollection = FirebaseFirestore.instance.collection(userEmail);
    for (int i = 0; i < notesModel.notesCout; i++) {
      notesCollection
          .doc(notesModel.getNote(i).id)
          .set({
            'title': notesModel.getNote(i).noteTitle,
            'content': notesModel.getNote(i).noteContent,
            'label': notesModel.getNote(i).noteLable
          })
          .then((value) => print("Note added in firestore"))
          .catchError(
              (error) => print("There was an error while adding note: $error"));
    }
    _databaseHelper.deleteNoteDatabase();
  }
}
