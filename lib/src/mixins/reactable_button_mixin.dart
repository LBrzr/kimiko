import 'dart:async';

import 'package:flutter/material.dart';

import '/src/widgets/loading_icon.dart';

abstract class ReactableButtonWidget<T> extends StatefulWidget {
  const ReactableButtonWidget({
    Key? key,
    required this.onTap,
    this.enabled = true,
  }) : super(key: key);

  final FutureOr<T> Function() onTap;
  final bool enabled;
}

mixin ReactableButtonStateMixin<T extends ReactableButtonWidget> on State<T> {
  bool processing = false;

  Widget get loadingWidget => const Padding(
        padding: EdgeInsets.symmetric(vertical: 7.5),
        child: KimikoLoadingIcon(color: Colors.white),
      ); // const CupertinoActivityIndicator();

  void react() {
    if (!processing) {
      setState(() => processing = true);
      Future.value(widget.onTap()).whenComplete(() {
        if (mounted) {
          setState(() => processing = false);
        }
      });
    }
  }
}
