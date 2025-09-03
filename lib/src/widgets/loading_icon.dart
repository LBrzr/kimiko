import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class KimikoLoadingIcon extends StatelessWidget {
  const KimikoLoadingIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LoadingAnimationWidget.discreteCircle(
        color: color ?? theme.primaryColorLight, size: theme.iconTheme.size!);
  }
}
