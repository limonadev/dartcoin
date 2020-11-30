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
    final b = FieldElement(prime: prime, value: 7);

    var points = [
      [192, 105],
      [17, 56],
      [200, 119],
      [1, 193],
      [42, 99]
    ];

    for (var p in points) {
      var x = FieldElement(prime: prime, value: p[0]);
      var y = FieldElement(prime: prime, value: p[1]);

      print(y.pow(2) == x.pow(3) + b);
    }
  }
}
