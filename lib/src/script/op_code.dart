import 'dart:collection';

class OpCode {
  static Map<int, Function> functions = {
    118: _op_dup,
  };

  /// Operation called `OP_DUP` with code `118` or `0x76`.
  /// Duplicates and pushes the top element in the stack.
  static bool _op_dup(ListQueue<Object> stack) {
    var isValidOp = false;

    if (stack.isNotEmpty) {
      stack.add(stack.last);
      isValidOp = true;
    }

    return isValidOp;
  }
}
