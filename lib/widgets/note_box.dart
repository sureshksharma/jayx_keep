import 'package:flutter/material.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NoteBox extends StatelessWidget {
  Color? labelColor;
  final String text;
  final String? title;

  NoteBox({Key? key, required this.labelColor, required this.text, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(6),
      child: Consumer<AppState>(
        builder: (context, appState, child) => Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.8),
            color:
                appState.isDarkTheme ? kDarkThemeBackgroundColor : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: labelColor, size: 14),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(this.title ?? "Note",
                                maxLines: 1,
                                style: appState.isDarkTheme
                                    ? kNoteBoxNoteStyle.copyWith(
                                        color: Colors.white)
                                    : kNoteBoxNoteStyle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: appState.isDarkTheme ? Colors.white : Colors.grey,
                    thickness: 0.5,
                  ),
                ],
              ),
              Text(
                text,
                style: const TextStyle(height: 1.2),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                maxLines: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
