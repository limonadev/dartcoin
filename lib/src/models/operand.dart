import 'dart:math' as math;

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

@immutable
class Operand {
  Operand({@required this.value});

  factory Operand.zero() => Operand(value: 0);
  factory Operand.infinity() => Operand(value: INF);

  static const num INF = null;

  final num value;

  @override
  int get hashCode => ObjectUtils.buildHashCode([value]);

  bool get isInf => value == INF;

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
    } else if (other is num) {
      result = Operand(value: value * other);
    }

    return result;
  }

  Operand operator /(Operand other) {
    return Operand(
      value: value / other.value,
    );
  }

  Operand operator ~/(Operand other) {
    return Operand(
      value: value ~/ other.value,
    );
  }

  Operand pow(num exponent) {
    return Operand(
      value: math.pow(value, exponent),
    );
  }

  @override
  String toString() {
    return '$value';
  }
}
