import 'package:flutter/material.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/screens/online_sync_screen.dart';
import 'package:jayx_keep/search_delegate/note_search.dart';
import 'package:provider/provider.dart';

class FloatingSearchBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  const FloatingSearchBar(
      {Key? key, required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(6),
      child: Consumer<AppState>(
        builder: (context, appState, child) => Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: appState.isDarkTheme
                ? kSurfaceColorDark.withOpacity(0.73)
                : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: const Icon(Icons.menu, size: kIconSize),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: NoteSearchClass(),
                      );
                    },
                    child: const Text(
                      'Search your Notes',
                      style: TextStyle(fontSize: 18, color: kGreyTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => const OnlineSyncScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.cloud_upload_rounded,
                    color: kPurpleColor,
                    size: kIconSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
