import 'package:flutter/material.dart';

import 'features/home/ui/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Url Alias App',
    home: HomePage(),
  );
}
