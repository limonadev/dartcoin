import 'package:dartcoin/dartcoin.dart';

class ChapterThree {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Three');
    _first();
    _second();

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
      _optional_second();
      _optional_third();
      _optional_fourth();
    }
  }

  /// Exercise 4 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _first() {
    print('First Exercise');
    const prime = 223;

    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);
    final x = FieldElement.fromNumbers(prime: prime, value: 47);
    final y = FieldElement.fromNumbers(prime: prime, value: 71);

    final point = Point(a: a, b: b, x: x, y: y);

    for (var i = 1; i < 21; i++) {
      print(point * i);
    }
  }

  /// Exercise 5 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/Chapter3.ipynb
  void _second() {
    print('Second Exercise');
    const prime = 223;

    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);
    final x = FieldElement.fromNumbers(prime: prime, value: 15);
    final y = FieldElement.fromNumbers(prime: prime, value: 86);

    final point = Point(a: a, b: b, x: x, y: y);

    print(point * 7);
  }

  /// Exercise 1 from Programming Bitcoin book - Chapter 3
  void _optional_first() {
    print('Optional First Exercise');

    const prime = 223;
    final b = FieldElement.fromNumbers(prime: prime, value: 7);

    var points = [
      [192, 105],
      [17, 56],
      [200, 119],
      [1, 193],
      [42, 99]
    ];

    for (var p in points) {
      var x = FieldElement.fromNumbers(prime: prime, value: p[0]);
      var y = FieldElement.fromNumbers(prime: prime, value: p[1]);

      print(y.pow(2) == x.pow(3) + b);
    }
  }

  /// Exercise 2 from Programming Bitcoin book - Chapter 3
  void _optional_second() {
    print('Optional Second Exercise');

    const prime = 223;
    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);

    var pointsA = [
      [192, 105],
      [170, 142],
      [47, 71],
      [143, 98]
    ];
    var pointsB = [
      [17, 56],
      [60, 139],
      [17, 56],
      [76, 66]
    ];

    for (var i = 0; i < pointsA.length; i++) {
      var p1 = pointsA[i];
      var p2 = pointsB[i];

      var first = Point(
        a: a,
        b: b,
        x: FieldElement.fromNumbers(prime: prime, value: p1[0]),
        y: FieldElement.fromNumbers(prime: prime, value: p1[1]),
      );
      var second = Point(
        a: a,
        b: b,
        x: FieldElement.fromNumbers(prime: prime, value: p2[0]),
        y: FieldElement.fromNumbers(prime: prime, value: p2[1]),
      );

      print(first + second);
    }
  }

  /// Exercise 5 from Programming Bitcoin book - Chapter 3
  void _optional_third() {
    print('Optional Third Exercise');

    const prime = 223;
    final a = FieldElement.fromNumbers(prime: prime, value: 0);
    final b = FieldElement.fromNumbers(prime: prime, value: 7);

    final genPoint = Point(
      a: a,
      b: b,
      x: FieldElement.fromNumbers(prime: prime, value: 15),
      y: FieldElement.fromNumbers(prime: prime, value: 86),
    );

    var sum = genPoint.copy();

    var order = 1;
    while (!sum.isPointAtInfinity) {
      sum += genPoint;
      order++;
    }

    print(order);
  }

  /// Exercise on page 60 from Programming Bitcoin book - Chapter 3
  void _optional_fourth() {
    final gx = BigInt.parse(
      '79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798',
      radix: 16,
    );
    final gy = BigInt.parse(
      '483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8',
      radix: 16,
    );
    final p = BigInt.two.pow(256) - BigInt.two.pow(32) - BigInt.from(977);
    final n = BigInt.parse(
      'fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141',
      radix: 16,
    );
    final x = FieldElement(prime: p, value: gx);
    final y = FieldElement(prime: p, value: gy);
    final g = Point(
      a: FieldElement(prime: p, value: BigInt.zero),
      b: FieldElement(prime: p, value: BigInt.from(7)),
      x: x,
      y: y,
    );

    print(g * n);
  }
}
