import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/ecc.py
void main() {
  test('test_ne', () {
    var a = FieldElement(number: 2, prime: 31);
    var b = FieldElement(number: 2, prime: 31);
    var c = FieldElement(number: 15, prime: 31);

    expect(a, equals(b));
    expect(a != c, true);
    expect(a != b, false);
  });

  test('test_add', () {
    var a = FieldElement(number: 2, prime: 31);
    var b = FieldElement(number: 15, prime: 31);

    expect(
      a + b,
      equals(FieldElement(number: 17, prime: 31)),
    );

    a = FieldElement(number: 17, prime: 31);
    b = FieldElement(number: 21, prime: 31);

    expect(
      a + b,
      equals(FieldElement(number: 7, prime: 31)),
    );
  });

  test('test_sub', () {
    var a = FieldElement(number: 29, prime: 31);
    var b = FieldElement(number: 4, prime: 31);

    expect(
      a - b,
      equals(FieldElement(number: 25, prime: 31)),
    );

    a = FieldElement(number: 15, prime: 31);
    b = FieldElement(number: 30, prime: 31);

    expect(
      a - b,
      equals(FieldElement(number: 16, prime: 31)),
    );
  });

  test('test_mul', () {
    var a = FieldElement(number: 24, prime: 31);
    var b = FieldElement(number: 19, prime: 31);

    expect(
      a * b,
      equals(FieldElement(number: 22, prime: 31)),
    );
  });
}
