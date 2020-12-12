import 'dart:typed_data';

import 'package:dartcoin/src/transaction/transaction.dart';
import 'package:dartcoin/src/transaction/varint.dart';
import 'package:dartcoin/src/utils/all.dart';

enum Parsing {
  Version,
  TxInsVarint,
  TxIns,
  TxOuts,
  Locktime,
}

class TransactionFactory {
  static Future<Transaction> parse(Stream<int> stream) async {
    final acc = <int>[];
    var currentStep = Parsing.Version;

    int txInVarintByteNumber;
    BigInt txInVarint;

    int version;

    await for (var byte in stream) {
      acc.add(byte);
      if (acc.length == 4 && currentStep == Parsing.Version) {
        version = ObjectUtils.bytesToBigInt(
          bytes: Uint8List.fromList(acc),
          endian: Endian.little,
        ).toInt();

        acc.clear();
        currentStep = Parsing.TxInsVarint;
      } else if (currentStep == Parsing.TxInsVarint) {
        /// TODO: Fix probably error on parsing (see ScriptFactory)
        if (txInVarintByteNumber == null) {
          txInVarintByteNumber = Varint.numberOfNecessaryBytes(flag: byte);
        } else if (acc.length == txInVarintByteNumber + 1) {
          txInVarint = Varint.read(bytes: acc);

          acc.clear();
          currentStep = Parsing.TxIns;
        }
      }
    }

    return Transaction(
      locktime: null,
      testnet: null,
      txIns: [],
      txOuts: null,
      version: version,
    );
  }
}
