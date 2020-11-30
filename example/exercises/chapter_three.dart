import 'package:dartcoin/dartcoin.dart';

class ChapterThree {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Three');

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
    }
  }

  /// Exercise 1 from Programming Bitcoin book - Chapter 3
  void _optional_first() {
    print('Optional First Exercise');

    const prime = 223;
    final b = FieldElement(number: 7, prime: prime);

    var points = [
      [192, 105],
      [17, 56],
      [200, 119],
      [1, 193],
      [42, 99]
    ];

    for (var p in points) {
      var x = FieldElement(number: p[0], prime: prime);
      var y = FieldElement(number: p[1], prime: prime);

      print(y.pow(2) == x.pow(3) + b);
    }
  }
}
