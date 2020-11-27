import 'package:dartcoin/dartcoin.dart';

class ChapterOne {
  void runEverything() {
    print('Run each exercise from Chapter One');
    _first();
    _second();
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
}
