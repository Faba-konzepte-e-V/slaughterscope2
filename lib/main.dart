import 'package:compassion_map/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/slaughterhouse_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SlaughterhouseProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MapScreen(),
      ),
    );
  }
}
