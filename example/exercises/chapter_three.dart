import 'package:dartcoin/dartcoin.dart';

class ChapterThree {
  void runEverything({bool runOptionals = false}) {
    print('Run each exercise from Chapter Three');

    if (runOptionals) {
      print('Optional exercises');
      _optional_first();
      _optional_second();
      _optional_third();
    }
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
}
