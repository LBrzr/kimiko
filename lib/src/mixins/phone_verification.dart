import 'dart:async' show Completer;

import 'package:flutter/material.dart';

import 'package:rxdart/subjects.dart';

import '/src/mixins/reactable_button_mixin.dart';
import '/src/models/snack_bar.dart';
import '/src/models/code.dart';
import '/src/resources/strings.dart';
import '/src/widgets/country_code.dart';
import '/src/widgets/rich_text.dart';

mixin PhoneVerificationMixin<T extends StatefulWidget> on State<T> {
  final sendCodeKey = GlobalKey<ReactableButtonStateMixin>(),
      tryCodeKey = GlobalKey<ReactableButtonStateMixin>();
  final codeFieldKey = GlobalKey<FormState>(),
      codeKey = GlobalKey<CountryCodeWidgetState>();
  late PublishSubject trySubject;
  late ThemeData theme;
  late Size size;
  late MediaQueryData mediaQuery;
  late TextTheme textTheme;
  late TextStyle subtitleStyle, titleStyle;
  late AnimationController sendCodeController;
  final numberController = TextEditingController(),
      smsCodeController = TextEditingController();
  bool codeSent = false, numberVerified = false;
  late Completer<bool> tryCompleter;
  DateTime? birthdate, lastPhoneCheck;
  Code? lastCode;

  String? countryCode;
  String? verifiedCountryCode, verifiedNumber;

  @override
  void initState() {
    sendCodeController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    textTheme = theme.textTheme;
    mediaQuery = MediaQuery.of(context);
    size = mediaQuery.size;
    subtitleStyle = textTheme.titleMedium!
        .copyWith(fontWeight: FontWeight.bold, color: theme.disabledColor);
    titleStyle = textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold, color: textTheme.displaySmall?.color);
  }

  @override
  void dispose() {
    sendCodeController.dispose();
    super.dispose();
  }

  void onCodeSent(Code code) {
    if (code.state) {
      debugPrint("Code sent");
      sendCodeController.forward();
    } else {
      debugPrint("Code not sent");
    }
    setState(() => codeSent = code.state);
    ScaffoldMessenger.of(context).showSnackBar(KimikoSnackBar.code(code));
  }

  void onVerificationFailded(Code code) {
    debugPrint("VerificationFailded");
    trySubject.close();
    ScaffoldMessenger.of(context).showSnackBar(KimikoSnackBar.code(code));
    resendCode();
  }

  void onVerificationSuccessed(Code code) {
    tryCompleter.complete(true);
    trySubject.close();
    sendCodeController.reverse();
    setState(() {
      numberVerified = true;
      verifiedCountryCode = countryCode;
      verifiedNumber = numberController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(KimikoSnackBar.code(code));
  }

  void onWrongCode(Code code) {
    debugPrint("WrongCode");
    tryCompleter.complete(false);
    ScaffoldMessenger.of(context).showSnackBar(KimikoSnackBar.code(code));
  }

  TickerProvider get tickerProvider;

  bool canVerify();

  @mustCallSuper
  Future<bool> tryCode([_]) async {
    if (codeFieldKey.currentState!.validate()) {
      if (!tryCompleter.isCompleted) tryCompleter.complete(false);
      trySubject.add(smsCodeController.text);
      return (tryCompleter = Completer<bool>()).future;
    }
    return false;
  }

  @mustCallSuper
  Future verify([_]) async {
    if (canVerify()) {
      tryCompleter = Completer<bool>();
      trySubject = PublishSubject<String>();
      return _verifyPhone(
        phone: (countryCode ?? "") + numberController.text,
        tryStream: trySubject.stream,
        onCodeSent: onCodeSent,
        onVerificationFailded: onVerificationFailded,
        onVerificationSuccessed: onVerificationSuccessed,
        onWrongCode: onWrongCode,
      ).then(then);
    }
  }

  /// verify phone number
  Future _verifyPhone({
    required String phone,
    required Stream tryStream,
    required void Function(Code code) onCodeSent,
    required void Function(Code code) onVerificationFailded,
    required void Function(Code code) onVerificationSuccessed,
    required void Function(Code code) onWrongCode,
  });

  /// call back on verification ended
  ///
  /// useful specialy when needed to show up snackbar on
  Future then(result) async {}

  @mustCallSuper
  void resendCode() {
    if (!tryCompleter.isCompleted) tryCompleter.complete(false);
    sendCodeController.reverse();
    setState(() {
      codeSent = false;
      numberVerified = false;
    });
  }

  Widget get resendCodeBtn => AnimatedBuilder(
        builder: (context, child) => Visibility(
          visible: !sendCodeController.isDismissed,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: Opacity(opacity: sendCodeController.value, child: child!),
        ),
        animation: sendCodeController,
        child: KimikoRichText(
          normalText: KStrings.codeNotReceived.value,
          superText: KStrings.resendCode.value,
          onTap: resendCode,
        ),
      );
}
