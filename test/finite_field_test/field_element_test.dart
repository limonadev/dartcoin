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
}
