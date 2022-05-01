import 'package:flutter/material.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/widgets/about_section.dart';
import 'package:provider/provider.dart';

class HomeNavDrawer extends StatefulWidget {
  const HomeNavDrawer({Key? key}) : super(key: key);

  @override
  _HomeNavDrawerState createState() => _HomeNavDrawerState();
}

class _HomeNavDrawerState extends State<HomeNavDrawer> {
  bool isDarkThemeOn = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 20.0, bottom: 4.0),
              child: Text(
                "JayxKeep",
                style: TextStyle(fontSize: 26),
              ),
            ),
            const Divider(
              thickness: 1.0,
              color: kDarkThemeWhiteGrey,
            ),
            SwitchListTile(
              value: Provider.of<AppState>(context).isDarkTheme,
              onChanged: (value) {
                setState(() {
                  isDarkThemeOn = value;
                  Provider.of<AppState>(context, listen: false)
                      .setThemeBool(value);
                });
              },
              title: const Text(
                "Dark Mode",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              secondary: isDarkThemeOn
                  ? const Icon(Icons.wb_sunny_rounded)
                  : const Icon(Icons.wb_sunny_outlined),
            ),
            const Divider(
              thickness: 1.0,
              color: kDarkThemeWhiteGrey,
            ),
            const AboutSection()
          ],
        ),
      ),
    );
  }
}
