import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

/// Each test is based on https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch02/ecc.py
void main() {
  test('test_ne', () {
    var a = Point(a: 5, b: 7, x: 3, y: -7);
    var b = Point(a: 5, b: 7, x: 18, y: 77);

    expect(a != b, true);
    expect(a != a, false);
  });
}
