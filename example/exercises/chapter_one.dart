import 'package:dartcoin/dartcoin.dart';

class ChapterOne {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter One');
    _first();
    _second();
    _third();
    _fourth();
    _fifth();

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
      _optional_second();
      _optional_third();
    }
  }

  /// Exercise 0 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _first() {
    print('First Exercise');
    var a = FieldElement.fromNumbers(prime: 13, value: 7);
    var b = FieldElement.fromNumbers(prime: 13, value: 6);

    print(a == b);
    print(a == a);
  }

  /// Exercise 2 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _second() {
    print('Second Exercise');
    var a = FieldElement.fromNumbers(prime: 13, value: 7);
    var b = FieldElement.fromNumbers(prime: 13, value: 12);
    var c = FieldElement.fromNumbers(prime: 13, value: 6);

    print(a + b == c);
  }

  /// Exercise 5 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _third() {
    print('Third Exercise');
    var a = FieldElement.fromNumbers(prime: 13, value: 3);
    var b = FieldElement.fromNumbers(prime: 13, value: 12);
    var c = FieldElement.fromNumbers(prime: 13, value: 10);
    print(a * b == c);
  }

  /// Exercise 6 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _fourth() {
    print('Fourth Exercise');
    var a = FieldElement.fromNumbers(prime: 13, value: 3);
    var b = FieldElement.fromNumbers(prime: 13, value: 1);
    print(a.pow(3) == b);
  }

  /// Exercise 9 https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/Chapter1.ipynb
  void _fifth() {
    print('Fifth Exercise');
    var a = FieldElement.fromNumbers(prime: 13, value: 7);
    var b = FieldElement.fromNumbers(prime: 13, value: 8);
    print(a.pow(-3) == b);
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

  /// Exercise 8 from Programming Bitcoin book - Chapter 1
  void _optional_third() {
    print('Optional Third Exercise');

    const order = 31;

    /// The operation of n^(-i) in some order is equals to
    /// ( n ^ (order-i-1) ) % order
    var i = 1;
    var firstTerm = 24.modPow(order - i - 1, order);
    print((3 * firstTerm) % order);

    i = 3;
    print(17.modPow(order - i - 1, order));

    i = 4;
    firstTerm = 4.modPow(order - i - 1, order);
    print((firstTerm * 11) % order);
  }
}
