import 'dart:math';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class Point {
  Point({
    @required this.a,
    @required this.b,
    @required this.x,
    @required this.y,
  }) : assert(
          pow(y, 2) == pow(x, 3) + a * x + b,
          '($x,$y) is not in the curve',
        );

  final int a;
  final int b;
  final int x;
  final int y;

  @override
  bool operator ==(dynamic other) {
    var result = false;

    if (other is Point) {
      result = a == other.a && b == other.b && x == other.x && y == other.y;
    }

    return result;
  }

  @override
  int get hashCode => ObjectUtils.buildHashCode(
        [a, b, x, y],
      );
}
