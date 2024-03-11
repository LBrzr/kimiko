import '/src/models/code.dart';
import '/src/resources/strings.dart';

class KCodes {
  static final success = Code(KStrings.success.value, true),
      failed = Code(KStrings.failed.value, false),
      connexionFailed = Code(KStrings.connexionFailed.value, false),
      userInvalidCredentials =
          Code(KStrings.userInvalidCredentials.value, false),
      userCreated = Code(KStrings.userCreated.value, true),
      userUpdated = Code(KStrings.userUpdated.value, true),
      userProfileUpdated = Code(KStrings.userProfileUpdated.value, true),
      ppUpdated = Code(KStrings.ppUpdated.value, true),
      passwordUpdated = Code(KStrings.passwordUpdated.value, true),
      wrongPassword = Code(KStrings.wrongPassword.value, false),
      emailUpdated = Code(KStrings.emailUpdated.value, true),
      phoneNumberUpdated = Code(KStrings.phoneNumberUpdated.value, true),
      updateFailed = Code(KStrings.updateFailed.value, false),
      userConnected = Code(KStrings.userConnected.value, true),
      emailAlreadyUsed = Code(KStrings.emailAlreadyUsed.value, false),
      emailAvailable = Code(KStrings.emailAvailable.value, true),
      phoneNumberAlreadyUsed =
          Code(KStrings.phoneNumberAlreadyUsed.value, false),
      phoneNumberAvailable = Code(KStrings.phoneNumberAvailable.value, true),
      userDisconnected = Code(KStrings.userDisconnected.value, true),
      verificationCodeSent = Code(KStrings.verificationCodeSent.value, true),
      wrongVerificationCode = Code(KStrings.wrongVerificationCode.value, false),
      verificationFailed = Code(KStrings.verificationFailed.value, false),
      verificationFailedInvalidNumber =
          Code(KStrings.verificationFailedInvalidNumber.value, false),
      verificationFailedTooManyRequest =
          Code(KStrings.verificationFailedTooManyRequest.value, false),
      verificationFailedSessionExpired =
          Code(KStrings.verificationFailedSessionExpired.value, false),
      verificationSucceed = Code(KStrings.verificationSucceed.value, true),
      messageSent = Code(KStrings.messageSent.value, true),
      messageNotSent = Code(KStrings.messageNotSent.value, false),
      messageRemoved = Code(KStrings.messageRemoved.value, true),
      messageNotRemoved = Code(KStrings.messageNotRemoved.value, false),
      invalidFields = Code(KStrings.invalidFields.value, false);
}
