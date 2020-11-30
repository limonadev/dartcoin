import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/ecc.py
void main() {
  test('test_ne', () {
    var a = FieldElement(value: 2, prime: 31);
    var b = FieldElement(value: 2, prime: 31);
    var c = FieldElement(value: 15, prime: 31);

    expect(a, equals(b));
    expect(a != c, true);
    expect(a != b, false);
  });

  test('test_add', () {
    var a = FieldElement(value: 2, prime: 31);
    var b = FieldElement(value: 15, prime: 31);

    expect(
      a + b,
      equals(FieldElement(value: 17, prime: 31)),
    );

    a = FieldElement(value: 17, prime: 31);
    b = FieldElement(value: 21, prime: 31);

    expect(
      a + b,
      equals(FieldElement(value: 7, prime: 31)),
    );
  });

  test('test_sub', () {
    var a = FieldElement(value: 29, prime: 31);
    var b = FieldElement(value: 4, prime: 31);

    expect(
      a - b,
      equals(FieldElement(value: 25, prime: 31)),
    );

    a = FieldElement(value: 15, prime: 31);
    b = FieldElement(value: 30, prime: 31);

    expect(
      a - b,
      equals(FieldElement(value: 16, prime: 31)),
    );
  });

  test('test_mul', () {
    var a = FieldElement(value: 24, prime: 31);
    var b = FieldElement(value: 19, prime: 31);

    expect(
      a * b,
      equals(FieldElement(value: 22, prime: 31)),
    );
  });

  test('test_pow', () {
    var a = FieldElement(value: 17, prime: 31);

    expect(
      a.pow(3),
      equals(FieldElement(value: 15, prime: 31)),
    );

    a = FieldElement(value: 5, prime: 31);
    var b = FieldElement(value: 18, prime: 31);

    expect(
      a.pow(5) * b,
      equals(FieldElement(value: 16, prime: 31)),
    );
  });

  test('test_div', () {
    var a = FieldElement(value: 3, prime: 31);
    var b = FieldElement(value: 24, prime: 31);
    expect(
      a / b,
      equals(FieldElement(value: 4, prime: 31)),
    );

    a = FieldElement(value: 17, prime: 31);
    expect(
      a.pow(-3),
      FieldElement(value: 29, prime: 31),
    );

    a = FieldElement(value: 4, prime: 31);
    b = FieldElement(value: 11, prime: 31);
    expect(
      a.pow(-4) * b,
      equals(FieldElement(value: 13, prime: 31)),
    );
  });
}
