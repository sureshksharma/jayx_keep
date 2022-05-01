import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/screens/note_screen.dart';
import 'package:jayx_keep/widgets/floating_search_bar.dart';
import 'package:jayx_keep/widgets/home_nav_drawer.dart';
import 'package:jayx_keep/widgets/note_box.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xffBB86FC),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NoteScreen(),
            ),
          );
        },
      ),
      drawer: const HomeNavDrawer(),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingSearchBar(scaffoldKey: _scaffoldKey),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 4.0),
            child: Text(
              'Your Notes',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Provider.of<AppState>(context).notesModel.notesCout != 0
                ? Consumer<AppState>(
                    builder: (context, appState, child) =>
                        StaggeredGridView.countBuilder(
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 14.0),
                      crossAxisCount: 4,
                      physics: const BouncingScrollPhysics(),
                      itemCount: appState.notesModel.notesCout,
                      itemBuilder: (context, index) => Hero(
                        tag: 'note_box_$index',
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NoteScreen(
                                  noteIndex: index,
                                ),
                              ),
                            );
                          },
                          child: NoteBox(
                            title:
                                appState.notesModel.getNote(index).noteTitle ??
                                    "Note",
                            text:
                                appState.notesModel.getNote(index).noteContent,
                            labelColor: kLabelToColor[
                                appState.notesModel.getNote(index).noteLable],
                          ),
                        ),
                      ),
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(2),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            CupertinoIcons.doc_text_search,
                            size: 100,
                          ),
                          SizedBox(height: 50),
                          Text(
                            'You have not added any notes.\n\nPlease login again if you are a existing user.',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      )),
    );
  }
}
