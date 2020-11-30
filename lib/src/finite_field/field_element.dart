import 'package:dartcoin/src/models/operand.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

//TODO: Migrate to latest Dart SDK to enable null safety

@immutable
class FieldElement extends Operand {
  FieldElement({
    @required this.number,
    @required this.prime,
  })  : assert(number >= 0),
        assert(number < prime);

  final int number;
  final int prime;

  @override
  int get hashCode => ObjectUtils.buildHashCode([number, prime]);

  @override
  bool operator ==(dynamic other) {
    var result = false;

    if (other is FieldElement) {
      result = number == other.number && prime == other.prime;
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

    var number = (this.number + other.number) % prime;
    return buildInstanceWith(number: number, prime: prime);
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

    var number = (this.number - other.number) % prime;
    return buildInstanceWith(number: number, prime: prime);
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

    var number = (this.number * other.number) % prime;
    return buildInstanceWith(number: number, prime: prime);
  }

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

    var number = (this.number * other.number.modPow(prime - 2, prime)) % prime;
    return buildInstanceWith(number: number, prime: prime);
  }

  @override
  FieldElement pow(num exponent) {
    var realExponent = exponent % (prime - 1);
    var number = this.number.modPow(realExponent, prime);
    return buildInstanceWith(number: number, prime: prime);
  }

  /// Method to mimic the inheritance of the Python examples by using __class__ from
  /// https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch01/ecc.py#L33
  FieldElement buildInstanceWith({
    @required int number,
    @required int prime,
  }) {
    return FieldElement(
      number: number,
      prime: prime,
    );
  }

  @override
  String toString() {
    return 'FieldElement_$prime($number)';
  }
}
