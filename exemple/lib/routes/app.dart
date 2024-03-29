import 'package:flutter/material.dart';
import 'package:kimiko/kimiko.dart';

class AppRoute extends StatefulWidget {
  const AppRoute({super.key});

  @override
  State<AppRoute> createState() => _AppRouteState();
}

class _AppRouteState extends State<AppRoute> {
  void buttonClicked([data]) => print(data ?? "Clicked");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kimiko Demo'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Text("Icons"),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <IconData>[
                        KimikoIcons.x,
                        KimikoIcons.archive,
                        Icons.archive,
                        KimikoIcons.eye,
                        KimikoIcons.eye_closed,
                      ].map((icon) {
                        return Icon(icon);
                      }).toList(),
                    ),
                  ),
                  KimikoActionBar(
                    items: [
                      KimikoActionBarItem(
                        icon: KimikoIcons.apps,
                        title: 'Apps',
                        onPressed: buttonClicked,
                      ),
                      const KimikoActionBarDivider(),
                      KimikoActionBarItem(
                        icon: KimikoIcons.alert,
                        title: 'Alert',
                        onPressed: buttonClicked,
                      ),
                      KimikoActionBarItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onPressed: buttonClicked,
                      ),
                      const KimikoActionBarDivider(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
