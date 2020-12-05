import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

@immutable
class Operand {
  Operand({@required this.value});

  factory Operand.fromHex({
    @required String hex,
    int radix = 10,
  }) =>
      Operand(
        value: BigInt.parse(
          hex,
          radix: radix,
        ),
      );
  factory Operand.infinity() => Operand(value: INF);
  factory Operand.zero() => Operand(value: BigInt.zero);

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
    if (other.runtimeType == Operand) {
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

  Operand pow(dynamic exponent) {
    if (exponent is! int) {
      throw ArgumentError(
        'The exponent cannot be a ${exponent.runtimeType}',
      );
    }

    return Operand(
      value: value.pow(exponent),
    );
  }

  @override
  String toString() {
    return '$value';
  }
}
