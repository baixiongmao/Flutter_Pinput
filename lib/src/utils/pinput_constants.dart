part of '../pinput.dart';

/// The constant values for Pinput
class PinputConstants {
  const PinputConstants._();

  /// The default value [Pinput.smsCodeMatcher]
  static const defaultSmsCodeMatcher = '\\d{4,7}';

  /// The default value [Pinput.animationDuration]
  static const _animationDuration = Duration(milliseconds: 180);

  /// The default value [Pinput.length]
  static const _defaultLength = 4;

  static const _defaultSeparator = SizedBox(width: 8);

  /// The hidden text under the Pinput
  static TextStyle  _hiddenTextStyle(BuildContext context){
  return  TextStyle(fontSize: 1, height: 1, color: Colors.transparent);
  //   return TextStyle(
  //     fontSize: 16,
  //   );
  }

  ///

}
