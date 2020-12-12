import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/transaction/script.dart';

class TxInput {
  TxInput({
    @required this.prevIndex,
    @required this.prevTxId,
    @required Script scriptSig,
    @required BigInt sequence,
  })  : scriptSig = scriptSig ?? Script(cmds: null),
        sequence = sequence ??
            BigInt.parse(
              'ffffffff',
              radix: 16,
            );

  final BigInt prevIndex;
  final Uint8List prevTxId;
  final Script scriptSig;
  final BigInt sequence;

  @override
  String toString() {
    final id = ObjectUtils.bytesToBigInt(
      bytes: prevTxId,
      endian: Endian.little,
    );
    return '${ObjectUtils.toHex(value: id)}:$prevIndex';
  }
}
