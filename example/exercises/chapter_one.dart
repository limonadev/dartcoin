import 'package:dartcoin/dartcoin.dart';

class ChapterOne {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter One');
    _first();
    _second();
    _third();
    _fourth();

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
      _optional_second();
    }
  }

  /// Exercise 0 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _first() {
    print('First Exercise');
    var a = FieldElement(number: 7, prime: 13);
    var b = FieldElement(number: 6, prime: 13);

    print(a == b);
    print(a == a);
  }

  /// Exercise 2 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _second() {
    print('Second Exercise');
    var a = FieldElement(number: 7, prime: 13);
    var b = FieldElement(number: 12, prime: 13);
    var c = FieldElement(number: 6, prime: 13);

    print(a + b == c);
  }

  /// Exercise 5 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _third() {
    print('Third Exercise');
    var a = FieldElement(number: 3, prime: 13);
    var b = FieldElement(number: 12, prime: 13);
    var c = FieldElement(number: 10, prime: 13);
    print(a * b == c);
  }

  /// Exercise 6 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _fourth() {
    print('Fourth Exercise');
    var a = FieldElement(number: 3, prime: 13);
    var b = FieldElement(number: 1, prime: 13);
    print(a.pow(3) == b);
  }

  /// Exercise 5 from Programming Bitcoin book - Chapter 1
  void _optional_first() {
    print('Optional First Exercise');
    const order = 19;
    for (var k in [1, 3, 7, 13, 18]) {
      var result = [];
      for (var i = 0; i <= 18; i++) {
        result.add((i * k) % order);
      }
      result.sort();
      print(result);
    }
  }

  /// Exercise 7 from Programming Bitcoin book - Chapter 1
  void _optional_second() {
    print('Optional Second Exercise');
    for (var p in [7, 11, 17, 31]) {
      var result = [];
      for (var i = 1; i < p; i++) {
        result.add(i.modPow(p - 1, p));
      }
      print(result);
    }
  }
}
