import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

@immutable
class Operand {
  Operand({@required this.value});

  factory Operand.zero() => Operand(value: BigInt.zero);
  factory Operand.infinity() => Operand(value: INF);

  static const BigInt INF = null;

  final BigInt value;

  @override
  int get hashCode => ObjectUtils.buildHashCode([value]);

  bool get isInf => value == INF;
  bool get isZero => value == BigInt.zero;

  @override
  bool operator ==(dynamic other) {
    return value == other.value;
  }

  Operand operator +(Operand other) {
    return Operand(
      value: value + other.value,
    );
  }

  Operand operator -(Operand other) {
    return Operand(
      value: value - other.value,
    );
  }

  Operand operator *(dynamic other) {
    Operand result;
    if (other is Operand) {
      result = Operand(value: value * other.value);
    } else if (other is int) {
      result = Operand(value: value * BigInt.from(other));
    } else {
      throw ArgumentError(
        'Cannot multiply an Operand with a ${other.runtimeType}',
      );
    }

    return result;
  }

  // TODO: Check the non integer division
  /*Operand operator /(Operand other) {
    return Operand(
      value: value / other.value,
    );
  }*/

  Operand operator ~/(Operand other) {
    return Operand(
      value: value ~/ other.value,
    );
  }

  Operand copy() {
    return Operand(value: value);
  }

  Operand pow(int exponent) {
    return Operand(
      value: value.pow(exponent),
    );
  }

  @override
  String toString() {
    return '$value';
  }
}
