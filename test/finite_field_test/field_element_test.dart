import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/ecc.py
void main() {
  test('test_ne', () {
    var a = FieldElement(prime: 31, value: 2);
    var b = FieldElement(prime: 31, value: 2);
    var c = FieldElement(prime: 31, value: 15);

    expect(a, equals(b));
    expect(a != c, true);
    expect(a != b, false);
  });

  test('test_add', () {
    var a = FieldElement(prime: 31, value: 2);
    var b = FieldElement(prime: 31, value: 15);

    expect(
      a + b,
      equals(FieldElement(prime: 31, value: 17)),
    );

    a = FieldElement(prime: 31, value: 17);
    b = FieldElement(prime: 31, value: 21);

    expect(
      a + b,
      equals(FieldElement(prime: 31, value: 7)),
    );
  });

  test('test_sub', () {
    var a = FieldElement(prime: 31, value: 29);
    var b = FieldElement(prime: 31, value: 4);

    expect(
      a - b,
      equals(FieldElement(prime: 31, value: 25)),
    );

    a = FieldElement(prime: 31, value: 15);
    b = FieldElement(prime: 31, value: 30);

    expect(
      a - b,
      equals(FieldElement(prime: 31, value: 16)),
    );
  });

  test('test_mul', () {
    var a = FieldElement(prime: 31, value: 24);
    var b = FieldElement(prime: 31, value: 19);

    expect(
      a * b,
      equals(FieldElement(prime: 31, value: 22)),
    );
  });

  test('test_pow', () {
    var a = FieldElement(prime: 31, value: 17);

    expect(
      a.pow(3),
      equals(FieldElement(prime: 31, value: 15)),
    );

    a = FieldElement(prime: 31, value: 5);
    var b = FieldElement(prime: 31, value: 18);

    expect(
      a.pow(5) * b,
      equals(FieldElement(prime: 31, value: 16)),
    );
  });

  test('test_div', () {
    var a = FieldElement(prime: 31, value: 3);
    var b = FieldElement(prime: 31, value: 24);
    expect(
      a / b,
      equals(FieldElement(prime: 31, value: 4)),
    );

    a = FieldElement(prime: 31, value: 17);
    expect(
      a.pow(-3),
      FieldElement(prime: 31, value: 29),
    );

    a = FieldElement(prime: 31, value: 4);
    b = FieldElement(prime: 31, value: 11);
    expect(
      a.pow(-4) * b,
      equals(FieldElement(prime: 31, value: 13)),
    );
  });
}
