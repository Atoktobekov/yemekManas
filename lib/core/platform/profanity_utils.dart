import 'package:ManasYemek/core/config/profanity_config.dart';

String normalize(String text) {
  return text
      .toLowerCase()
      .replaceAll('ё', 'е')
  /// remove punctuation
      .replaceAll(RegExp(r'[0-9@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/?!]'), ' ')
  /// transliterate to russian
      .replaceAll('a', 'а').replaceAll('e', 'е').replaceAll('o', 'о')
      .replaceAll('p', 'р').replaceAll('c', 'с').replaceAll('y', 'у').replaceAll('x', 'х')
  /// delete duplicate letters
      .replaceAllMapped(RegExp(r'(.)\1+'), (match) => match.group(1)!)
      .trim();
}
bool containsProfanity(String text) {
  final normalized = normalize(text);

  return ProfanityConfig.forbiddenPatterns.any(
        (pattern) => RegExp(pattern).hasMatch(normalized),
  );
}