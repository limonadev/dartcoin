import 'dart:typed_data';

import 'package:dartcoin/src/transaction/script_factory.dart';
import 'package:dartcoin/src/transaction/transaction_input.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

class TxInputFactory {
  static ParsingResult<TxInput> parseSync({
    @required Uint8List bytes,
    int initialIndex = 0,
  }) {
    final prevTxId = bytes.sublist(
      initialIndex,
      initialIndex + 32,
    );
    initialIndex += 32;

    final prevTxIndex = bytes.sublist(initialIndex, initialIndex + 4);
    initialIndex += 4;

    final scriptSigResult = ScriptFactory.parseSync(
      bytes: bytes,
      initialIndex: initialIndex,
    );
    initialIndex = scriptSigResult.currentBytePosition;
    final scriptSig = scriptSigResult.result;

    final sequence = ObjectUtils.bytesToBigInt(
      bytes: bytes.sublist(initialIndex, initialIndex + 4),
      endian: Endian.little,
    );
    initialIndex += 4;

    final txInput = TxInput(
      prevTxId: prevTxId,
      prevTxIndex: prevTxIndex,
      scriptSig: scriptSig,
      sequence: sequence,
    );
    return ParsingResult(
      currentBytePosition: initialIndex,
      result: txInput,
    );
  }
}
