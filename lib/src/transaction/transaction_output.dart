import 'dart:typed_data';

import 'package:dartcoin/src/transaction/script.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class TxOutput {
  TxOutput({
    @required this.amount,
    @required this.scriptPubkey,
  });

  final BigInt amount;
  final Script scriptPubkey;

  Uint8List serialize() {
    final result = <int>[
      ...ObjectUtils.bigIntToBytes(
        number: amount,
        endian: Endian.little,
        size: 8,
      ),
      ...scriptPubkey.serialize(),
    ];

    return Uint8List.fromList(result);
  }

  @override
  String toString() {
    return '$amount $scriptPubkey';
  }
}
