import 'package:flutter/material.dart';

import '/src/widgets/loading_icon.dart';

abstract class ReactableButtonWidget extends StatefulWidget {
  const ReactableButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Future Function() onTap;
}

mixin ReactableButtonStateMixin<T extends ReactableButtonWidget> on State<T> {
  bool processing = false;

  Widget get loadingWidget => const Padding(
        padding: EdgeInsets.symmetric(vertical: 7.5),
        child: KimikoLoadingIcon(color: Colors.white),
      ); // const CupertinoActivityIndicator();

  void react() {
    setState(() => processing = true);
    widget.onTap().whenComplete(() {
      if (mounted) {
        setState(() => processing = false);
      }
    });
  }
}
