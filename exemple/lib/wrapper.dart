import 'package:flutter/material.dart';

import 'package:kimiko/kimiko.dart';

import '/routes/app.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kimiko Demo',
      theme: KimikoConstants.theme,
      home: const AppRoute(),
    );
  }
}
