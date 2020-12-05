import 'package:dartcoin/src/models/operand.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

@immutable
class FieldElement extends Operand {
  FieldElement({
    @required this.prime,
    @required BigInt value,
  })  : assert(value >= BigInt.zero),
        assert(value < prime),
        super(value: value);

  factory FieldElement.fromBigNumbers({
    @required BigInt prime,
    @required BigInt value,
  }) {
    return FieldElement(
      prime: prime,
      value: value,
    );
  }

  factory FieldElement.fromNumbers({
    @required int prime,
    @required int value,
  }) {
    return FieldElement(
      prime: BigInt.from(prime),
      value: BigInt.from(value),
    );
  }

  final BigInt prime;

  @override
  int get hashCode => ObjectUtils.buildHashCode([value, prime]);

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
    FieldElement other;

    if (o is FieldElement) {
      other = o;
    } else if (o.runtimeType == Operand) {
      other = FieldElement(prime: prime, value: o.value);
    } else if (o is int) {
      other = FieldElement(prime: prime, value: BigInt.from(o));
    } else {
      throw ArgumentError(
        'Cannot multiply a FieldElement with a ${o.runtimeType}',
      );
    }

    if (prime != other.prime) {
      throw ArgumentError('Cannot multiply two numbers in different Fields');
    }

    var number = (value * other.value) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  // TODO: Check the non integer division
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

    var number =
        (value * other.value.modPow(prime - BigInt.two, prime)) % prime;
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

    var number =
        (value * other.value.modPow(prime - BigInt.two, prime)) % prime;
    return buildInstanceWith(value: number, prime: prime);
  }

  @override
  FieldElement pow(dynamic exponent) {
    if (exponent is! int && exponent is! BigInt) {
      throw ArgumentError(
        'The exponent cannot be a ${exponent.runtimeType}',
      );
    }

    final e = exponent is int ? BigInt.from(exponent) : exponent;
    var realExponent = e % (prime - BigInt.one);
    var number = value.modPow(realExponent, prime);
    return buildInstanceWith(value: number, prime: prime);
  }

  /// Method to mimic the inheritance of the Python examples by using __class__ from
  /// https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/ecc.py#L33
  FieldElement buildInstanceWith({
    @required BigInt value,
    @required BigInt prime,
  }) {
    return FieldElement(
      value: value,
      prime: prime,
    );
  }

  @override
  FieldElement copy() {
    return FieldElement(prime: prime, value: value);
  }

  @override
  String toString() {
    return 'FieldElement_$prime($value)';
  }
}
