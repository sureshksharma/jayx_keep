import 'package:flutter/material.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/models/note_model.dart';
import 'package:jayx_keep/widgets/label_selector_dialog.dart';
import 'package:jayx_keep/widgets/note_writing_section.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class NoteScreen extends StatefulWidget {
  final int? noteIndex;
  const NoteScreen({Key? key, this.noteIndex}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late NoteModel _note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.noteIndex != null) {
      _note = NoteModel(
          noteTitle: Provider.of<AppState>(context)
              .notesModel
              .getNote(widget.noteIndex!)
              .noteTitle,
          noteContent: Provider.of<AppState>(context)
              .notesModel
              .getNote(widget.noteIndex!)
              .noteContent,
          noteLable: Provider.of<AppState>(context)
              .notesModel
              .getNote(widget.noteIndex!)
              .noteLable,
          id: Provider.of<AppState>(context)
              .notesModel
              .getNote(widget.noteIndex!)
              .id);
    } else {
      _note = NoteModel(noteContent: '');
    }
  }

  void editNoteTitle(String newTitle) {
    /// This is a callback that allows the NoteWritingScreen to edit the note
    /// object in this class.
    _note.noteTitle = newTitle;
  }

  void editNoteContent(String newContent) {
    /// This is a callback that allows the NoteWritingScreen to edit the note
    /// object in this class.
    _note.noteContent = newContent;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Consumer<AppState>(
      builder: (context, appState, child) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: appState.isDarkTheme
                ? kLightThemeBackgroundColor
                : kDarkThemeBackgroundColor,
          ),
          elevation: 0.0,
          title: Text(
            'Your Note',
            style: TextStyle(
                color: appState.isDarkTheme
                    ? kLightThemeBackgroundColor
                    : kDarkThemeBackgroundColor),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Every new note must have some content.
                if (_note.noteContent != '') {
                  appState.saveNote(_note, widget.noteIndex);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter some content for the note."),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.check,
                color: appState.isDarkTheme
                    ? kLightThemeBackgroundColor
                    : kDarkThemeBackgroundColor,
              ),
            ),
          ],
        ),
        body: Hero(
          tag: widget.noteIndex != null
              ? 'note_box_${widget.noteIndex}'
              : 'note_box',
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: deviceHeight -
                      (MediaQuery.of(context).padding.top + kToolbarHeight),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceHeight * 0.01,
                              vertical: deviceWidth * 0.015),
                          child: NoteWritingSection(
                            startingTitle: _note.noteTitle,
                            startingContent: _note.noteContent,
                            editNoteTitleCallback: editNoteTitle,
                            editNoteContentCallback: editNoteContent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      BottomNoteOption(
                          note: _note,
                          deviceHeight: deviceHeight,
                          deviceWidth: deviceWidth,
                          deleteNoteCallback: () {
                            if (widget.noteIndex != null) {
                              appState.deleteNote(_note);
                            }
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNoteOption extends StatefulWidget {
  NoteModel note;
  final Function? deleteNoteCallback;
  final double deviceHeight;
  final double deviceWidth;
  BottomNoteOption(
      {Key? key,
      required this.note,
      required this.deviceHeight,
      required this.deviceWidth,
      required this.deleteNoteCallback})
      : super(key: key);

  @override
  State<BottomNoteOption> createState() => _BottomNoteOptionState();
}

class _BottomNoteOptionState extends State<BottomNoteOption> {
  void changeLabelCallback(int newLabelIndex) {
    setState(() {
      widget.note.noteLable = newLabelIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.deviceHeight * 0.09,
      child: Material(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return LabelSelectorDialog(
                        selectedLabel: widget.note.noteLable,
                        deviceWidth: widget.deviceWidth,
                        changeLabelCallback: changeLabelCallback,
                      );
                    });
              },
              icon: Icon(
                Icons.star,
                color: kLabelToColor[widget.note.noteLable],
              ),
              iconSize: 28,
            ),
            IconButton(
              onPressed: () {
                widget.deleteNoteCallback!.call();
              },
              icon: const Icon(Icons.delete_outline),
              iconSize: 28,
            ),
            IconButton(
              onPressed: () {
                if (widget.note.noteContent.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('There is no content in the note to share.'),
                    ),
                  );
                } else {
                  Share.share(widget.note.noteContent);
                }
              },
              icon: const Icon(Icons.share_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
