import 'package:dartcoin/dartcoin.dart';

class ChapterOne {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter One');
    _first();
    _second();
    if (runOptionals) _optional_third();
  }

  void _first() {
    print('First Exercise');
    var a = FieldElement(number: 7, prime: 13);
    var b = FieldElement(number: 6, prime: 13);

    print(a == b);
    print(a == a);
  }

  void _second() {
    print('Second Exercise');
    var a = FieldElement(number: 7, prime: 13);
    var b = FieldElement(number: 12, prime: 13);
    var c = FieldElement(number: 6, prime: 13);

    print(a + b == c);
  }

  void _optional_third() {
    print('Optional Third Exercise');
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
}
