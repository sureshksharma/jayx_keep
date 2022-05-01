import 'package:flutter/material.dart';
import 'package:jayx_keep/app_state.dart';
import 'package:jayx_keep/constants.dart';
import 'package:jayx_keep/screens/home_screen.dart';
import 'package:provider/provider.dart';

late AppState appState;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appState = AppState();
  await appState.initialization().then((_) => appState.readNotes());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => appState,
        child: Builder(
          builder: (context) => MaterialApp(
            title: 'Jayx Keep',
            theme: Provider.of<AppState>(context).isDarkTheme
                ? ThemeData.dark()
                    .copyWith(primaryColor: kDarkThemeBackgroundColor)
                : ThemeData.light()
                    .copyWith(primaryColor: kLightThemeBackgroundColor),
            home: HomeScreen(),
          ),
        ));
  }
}
