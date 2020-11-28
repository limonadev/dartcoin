import 'package:dartcoin/dartcoin.dart';

class ChapterTwo {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Two');
    _first();
    _second();

    if (runOptionals) {
      print('Optional exercises');
    }
  }

  /// Exercise 0 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch02/Chapter2.ipynb
  void _first() {
    print('First Exercise');
    Point(a: 5, b: 7, x: -1, y: -1);
    try {
      Point(a: 5, b: 7, x: -1, y: -2);
    } catch (e) {
      print('EXPECTED FAILED ASSERTION:\n$e');
    }
  }

  /// Exercise 2 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch02/Chapter2.ipynb
  void _second() {
    var p1 = Point(a: 5, b: 7, x: -1, y: -1);
    var p2 = Point(a: 5, b: 7, x: -1, y: 1);
    var inf = Point.atInfinity(a: 5, b: 7);
    print(p1 + inf);
    print(inf + p2);
    print(p1 + p2);
  }
}
