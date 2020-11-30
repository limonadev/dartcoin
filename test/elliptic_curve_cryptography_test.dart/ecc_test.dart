import 'package:dartcoin/dartcoin.dart';
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
}
