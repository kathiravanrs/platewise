import 'package:flutter/material.dart';
import 'package:platewise/screens/add_friends.dart';
import 'package:platewise/screens/add_items.dart';
import 'package:platewise/screens/assign_items.dart';
import 'package:platewise/screens/home_page.dart';
import 'package:platewise/screens/review_screen.dart';

import 'data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  savedInstances = await loadSplitInstances();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
      routes: {
        AddFriendsScreen.routeName: (context) => const AddFriendsScreen(),
        AddItemsScreen.routeName: (context) => const AddItemsScreen(),
        ReviewScreen.routeName: (context) => const ReviewScreen(),
        AssignItemsScreen.routeName: (context) =>
            AssignItemsScreen(friends: friends, items: items),
      },
    );
  }
}
