library action_bar;

import 'package:flutter/material.dart';

import './src/models/item.dart';

export './src/models/item.dart';
export './src/widgets/icon.dart';

class KimikoActionBar extends StatefulWidget {
  const KimikoActionBar({super.key, required this.items});

  final List<KimikoActionBarEntry> items;

  @override
  State<KimikoActionBar> createState() => _KimikoActionBarState();
}

class _KimikoActionBarState extends State<KimikoActionBar> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.items.map((item) => item.buildIcon(context)).toList(),
      ),
    );
  }
}
