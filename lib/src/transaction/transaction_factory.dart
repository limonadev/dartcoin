import 'dart:typed_data';

import 'package:dartcoin/src/transaction/transaction.dart';
import 'package:dartcoin/src/utils/all.dart';

enum Parsing {
  Version,
  TxIns,
  TxOuts,
  Locktime,
}

class TransactionFactory {
  static Future<Transaction> parse(Stream<int> stream) async {
    var currentStep = Parsing.Version;

    final acc = <int>[];
    int version;

    await for (var byte in stream) {
      acc.add(byte);
      if (acc.length == 4 && currentStep == Parsing.Version) {
        version = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList(acc),
          endian: Endian.little,
        ).toInt();

        acc.clear();
        currentStep = Parsing.TxIns;
      }
    }

    return Transaction(
      locktime: null,
      testnet: null,
      txIns: null,
      txOuts: null,
      version: version,
    );
  }
}
