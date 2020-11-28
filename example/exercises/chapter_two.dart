import 'package:dartcoin/dartcoin.dart';

class ChapterTwo {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Two');
    _first();

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
}
