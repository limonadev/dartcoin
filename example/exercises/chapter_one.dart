import 'package:dartcoin/dartcoin.dart';

class ChapterOne {
  void runEverything() {
    print('Run each exercise from Chapter One');
    _first();
  }

  void _first() {
    var a = FieldElement(number: 7, prime: 13);
    var b = FieldElement(number: 6, prime: 13);

    print(a == b);
    print(a == a);
  }
}
