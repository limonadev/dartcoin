import 'package:dartcoin/dartcoin.dart';
import 'package:dartcoin/src/models/operand.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch03/ecc.py
void main() {
  test('test_on_curve', () {
    const prime = 223;

    var a = FieldElement(prime: prime, value: 0);
    var b = FieldElement(prime: prime, value: 7);

    var validPoints = [
      [192, 105],
      [17, 56],
      [1, 193]
    ];
    var invalidPoints = [
      [200, 119],
      [42, 99]
    ];

    for (var p in validPoints) {
      var x = FieldElement(prime: prime, value: p[0]);
      var y = FieldElement(prime: prime, value: p[1]);

      expect(
        () => Point(a: a, b: b, x: x, y: y),
        returnsNormally,
      );
    }

    for (var p in invalidPoints) {
      var x = FieldElement(prime: prime, value: p[0]);
      var y = FieldElement(prime: prime, value: p[1]);

      expect(
        () => Point(a: a, b: b, x: x, y: y),
        throwsA(isA<AssertionError>()),
      );
    }
  });

  test('test_add', () {
    const prime = 223;

    final a = FieldElement(prime: prime, value: 0);
    final b = FieldElement(prime: prime, value: 7);

    var pointsA = [
      [192, 105],
      [47, 71],
      [143, 98]
    ];
    var pointsB = [
      [17, 56],
      [117, 141],
      [76, 66]
    ];
    var results = [
      [170, 142],
      [60, 139],
      [47, 71]
    ];

    for (var i = 0; i < pointsA.length; i++) {
      var p1 = pointsA[i];
      var p2 = pointsB[i];
      var r = results[i];

      var first = Point(
        a: a,
        b: b,
        x: FieldElement(prime: prime, value: p1[0]),
        y: FieldElement(prime: prime, value: p1[1]),
      );
      var second = Point(
        a: a,
        b: b,
        x: FieldElement(prime: prime, value: p2[0]),
        y: FieldElement(prime: prime, value: p2[1]),
      );

      expect(
        first + second,
        equals(
          Point(
            a: a,
            b: b,
            x: FieldElement(
              prime: prime,
              value: r[0],
            ),
            y: FieldElement(
              prime: prime,
              value: r[1],
            ),
          ),
        ),
      );
    }
  });

  test('test_rmul', () {
    const prime = 223;
    final a = FieldElement(prime: prime, value: 0);
    final b = FieldElement(prime: prime, value: 7);

    var coefficients = [2, 2, 2, 4, 8, 21];
    var points = [
      [192, 105],
      [143, 98],
      [47, 71],
      [47, 71],
      [47, 71],
      [47, 71]
    ];
    var results = [
      [49, 71],
      [64, 168],
      [36, 111],
      [194, 51],
      [116, 55],
      [null, null]
    ];

    for (var i = 0; i < coefficients.length; i++) {
      var x = FieldElement(prime: prime, value: points[i][0]);
      var y = FieldElement(prime: prime, value: points[i][1]);

      var p = Point(a: a, b: b, x: x, y: y);

      expect(
        p * coefficients[i],
        equals(
          results[i][0] != null
              ? Point(
                  a: a,
                  b: b,
                  x: FieldElement(prime: prime, value: results[i][0]),
                  y: FieldElement(prime: prime, value: results[i][1]),
                )
              : Point.atInfinity(
                  a: a,
                  b: b,
                ),
        ),
      );
    }
  });
}
