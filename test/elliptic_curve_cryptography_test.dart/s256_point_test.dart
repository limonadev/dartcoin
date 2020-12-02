import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  test('test_order', () {
    final point = Secp256Utils.generator * Secp256Utils.order;

    expect(
      point.isPointAtInfinity,
      equals(true),
    );
  });
}
