import 'dart:typed_data';

import 'package:dartcoin/src/script/all.dart';
import 'package:dartcoin/src/transaction/transaction_output.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class TxOutputFactory {
  static ParsingResult<TxOutput> parseSync({
    @required Uint8List bytes,
    int initialIndex = 0,
  }) {
    final amountBytes = bytes.sublist(
      initialIndex,
      initialIndex + 8,
    );
    final amount = ObjectUtils.bytesToBigInt(
      bytes: amountBytes,
      endian: Endian.little,
    );
    initialIndex += 8;

    final scriptPubKeyResult = ScriptFactory.parseSync(
      bytes: bytes,
      initialIndex: initialIndex,
    );
    initialIndex = scriptPubKeyResult.currentBytePosition;
    final scriptPubKey = scriptPubKeyResult.result;

    final txOutput = TxOutput(
      amount: amount,
      scriptPubkey: scriptPubKey,
    );
    return ParsingResult(
      currentBytePosition: initialIndex,
      result: txOutput,
    );
  }
}
