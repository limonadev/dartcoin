import 'package:dartcoin/src/models/operand.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

//TODO: Migrate to latest Dart SDK to enable null safety

@immutable
class FieldElement extends Operand {
  FieldElement({
    @required this.prime,
    @required int value,
  })  : assert(value >= 0),
        assert(value < prime),
        super(value: value);

  final int prime;

  @override
  int get hashCode => ObjectUtils.buildHashCode([value, prime]);

  @override
  int get value => super.value.toInt();

  @override
  bool operator ==(dynamic other) {
    var result = false;

    if (other is FieldElement) {
      result = value == other.value && prime == other.prime;
    }

    return result;
  }

  @override
  FieldElement operator +(Operand o) {
    if (o is! FieldElement) {
      throw ArgumentError(
        'Cannot add a FieldElement with a ${o.runtimeType}',
      );
    }

    var other = o as FieldElement;

    if (prime != other.prime) {
      throw ArgumentError('Cannot add two numbers in different Fields');
    }

    var number = (value + other.value) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  @override
  FieldElement operator -(Operand o) {
    if (o is! FieldElement) {
      throw ArgumentError(
        'Cannot subtract a FieldElement with a ${o.runtimeType}',
      );
    }

    var other = o as FieldElement;

    if (prime != other.prime) {
      throw ArgumentError('Cannot subtract two numbers in different Fields');
    }

    var number = (value - other.value) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  @override
  FieldElement operator *(dynamic o) {
    if (o is! FieldElement) {
      throw ArgumentError(
        'Cannot multiply a FieldElement with a ${o.runtimeType}',
      );
    }

    var other = o as FieldElement;

    if (prime != other.prime) {
      throw ArgumentError('Cannot multiply two numbers in different Fields');
    }

    var number = (value * other.value) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  @override
  FieldElement operator /(Operand o) {
    if (o is! FieldElement) {
      throw ArgumentError(
        'Cannot divide a FieldElement with a ${o.runtimeType}',
      );
    }

    var other = o as FieldElement;

    if (prime != other.prime) {
      throw ArgumentError('Cannot divide two numbers in different Fields');
    }

    var number = (value * other.value.modPow(prime - 2, prime)) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  @override
  FieldElement operator ~/(Operand o) {
    if (o is! FieldElement) {
      throw ArgumentError(
        'Cannot divide a FieldElement with a ${o.runtimeType}',
      );
    }

    var other = o as FieldElement;

    if (prime != other.prime) {
      throw ArgumentError('Cannot divide two numbers in different Fields');
    }

    var number = (value * other.value.modPow(prime - 2, prime)) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  @override
  FieldElement pow(num exponent) {
    var realExponent = exponent % (prime - 1);
    var number = value.modPow(realExponent, prime);
    return buildInstanceWith(value: number, prime: prime);
  }

  /// Method to mimic the inheritance of the Python examples by using __class__ from
  /// https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/ecc.py#L33
  FieldElement buildInstanceWith({
    @required int value,
    @required int prime,
  }) {
    return FieldElement(
      value: value,
      prime: prime,
    );
  }

  @override
  String toString() {
    return 'FieldElement_$prime($value)';
  }
}
