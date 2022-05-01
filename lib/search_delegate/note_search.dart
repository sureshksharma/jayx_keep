import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/screens/note_screen.dart';
import 'package:jayx_keep/widgets/note_box.dart';
import 'package:provider/provider.dart';

class NoteSearchClass extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // This will show a clear query button
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // A back button to close the search.
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return showSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // These are suggestions that will appear when user hasn't typed anything.
    return showSearchResults(context);
  }

  Widget showSearchResults(BuildContext context) {
    List<int> relevatIndexes =
        Provider.of<AppState>(context).notesModel.searchNotes(query);

    if (relevatIndexes.isEmpty) {
      return Center(
        child: Column(
          children: const [
            Icon(
              Icons.person_search,
              size: 100.0,
            ),
            Text('No Results Found.')
          ],
        ),
      );
    } else {
      print('showSearchResults');
      return Consumer<AppState>(
        builder: (context, appState, child) => StaggeredGridView.countBuilder(
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
          crossAxisCount: 4,
          physics: const BouncingScrollPhysics(),
          itemCount: relevatIndexes.length,
          itemBuilder: (context, index) => Hero(
            tag: 'note_box_$index',
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => NoteScreen(
                      noteIndex: relevatIndexes[index],
                    ),
                  ),
                );
              },
              child: NoteBox(
                title: appState.notesModel
                    .getNote(relevatIndexes[index])
                    .noteTitle,
                text: appState.notesModel
                    .getNote(relevatIndexes[index])
                    .noteContent,
                labelColor: kLabelToColor[appState.notesModel
                    .getNote(relevatIndexes[index])
                    .noteLable],
              ),
            ),
          ),
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
        ),
      );
    }
  }
}
