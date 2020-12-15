import 'dart:typed_data';

import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';
import 'package:dartcoin/src/transaction/script.dart';

class TxInput {
  TxInput({
    @required this.prevTxId,
    @required this.prevTxIndex,
    @required Script scriptSig,
    @required BigInt sequence,
  })  : scriptSig = scriptSig ?? Script(cmds: null),
        sequence = sequence ??
            BigInt.parse(
              'ffffffff',
              radix: 16,
            );

  /// The [prevTxId] is stored as a list of bytes, when is necessary to
  /// decode it ensure setting [Endian.little] as part of the process.
  final Uint8List prevTxId;
  final BigInt prevTxIndex;
  final Script scriptSig;
  final BigInt sequence;

  Uint8List serialize() {
    final result = <int>[
      ...prevTxId,
      ...ObjectUtils.bigIntToBytes(
        number: prevTxIndex,
        endian: Endian.little,
        size: 4,
      ),
      ...scriptSig.serialize(),
      ...ObjectUtils.bigIntToBytes(
        number: sequence,
        endian: Endian.little,
        size: 4,
      ),
    ];

    return Uint8List.fromList(result);
  }

  @override
  String toString() {
    final id = ObjectUtils.bytesToBigInt(
      bytes: prevTxId,
      endian: Endian.little,
    );
    return '${ObjectUtils.toHex(padding: 64, value: id)}:$prevTxIndex';
  }
}
