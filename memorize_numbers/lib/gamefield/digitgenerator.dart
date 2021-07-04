import 'dart:math';

class DigitGenerator {
  late Random _random;
  DigitGenerator() {
    _random = Random();
  }

  String generateRandomInteger(int max) {
    String generatedNumber = '';
    for (int i = 0; i < max; i++) {
      int randInt = _random.nextInt(10);
      generatedNumber += randInt.toString();
    }

    return generatedNumber;
  }
}
