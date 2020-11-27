import 'package:dartcoin/dartcoin.dart';
import 'package:test/test.dart';

void main() {
  group('HashCode', () {
    test('Single Value', () {
      expect(
        ObjectUtils.buildHashCode([1]),
        equals(
          ObjectUtils.buildHashCode([1]),
        ),
      );

      expect(
        ObjectUtils.buildHashCode([1]),
        isNot(
          equals(
            ObjectUtils.buildHashCode([2]),
          ),
        ),
      );
    });
  });
  test('Multiple Values', () {
    expect(
      ObjectUtils.buildHashCode([1, 2, 3]),
      equals(
        ObjectUtils.buildHashCode([1, 2, 3]),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, 'hi', 3]),
      equals(
        ObjectUtils.buildHashCode([1, 'hi', 3]),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, 'hi', 3]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1, 2, 'hi']),
        ),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, 2, 3]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1]),
        ),
      ),
    );
  });

  test('Null Values', () {
    expect(
      ObjectUtils.buildHashCode([null]),
      equals(
        ObjectUtils.buildHashCode([null]),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([null]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1]),
        ),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, null, 3]),
      isNot(
        equals(
          ObjectUtils.buildHashCode([1, 2, null]),
        ),
      ),
    );

    expect(
      ObjectUtils.buildHashCode([1, null, 3]),
      equals(
        ObjectUtils.buildHashCode([1, null, 3]),
      ),
    );
  });
}
