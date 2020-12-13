import 'dart:typed_data';

import 'package:dartcoin/src/transaction/transaction.dart';
import 'package:dartcoin/src/transaction/varint.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:meta/meta.dart';

enum Parsing {
  Version,
  TxInsVarint,
  TxIns,
  TxOuts,
  Locktime,
}

class ParsingResult<T> {
  ParsingResult({
    @required this.currentBytePosition,
    @required this.result,
  });

  final int currentBytePosition;
  final T result;
}

class TransactionFactory {
  static Transaction parseSync({@required Uint8List bytes}) {
    var currentByteIndex = 0;

    final versionResult = _parseVersion(
      bytes: bytes,
      currentByteIndex: currentByteIndex,
    );
    currentByteIndex = versionResult.currentBytePosition;
    final version = versionResult.result;

    final numberOfTxInputsResult = _parseNumberOfTxInputs(
      bytes: bytes,
      currentByteIndex: currentByteIndex,
    );
    currentByteIndex = numberOfTxInputsResult.currentBytePosition;
    final numberOfTxInputs = numberOfTxInputsResult.result;

    return Transaction(
      locktime: null,
      testnet: null,
      txIns: [],
      txOuts: null,
      version: version,
    );
  }

  static ParsingResult<int> _parseVersion({
    @required Uint8List bytes,
    @required int currentByteIndex,
  }) {
    return ParsingResult(
      currentBytePosition: currentByteIndex + 4,
      result: ObjectUtils.bytesToBigInt(
        bytes: Uint8List.fromList(
          bytes.sublist(currentByteIndex, currentByteIndex + 4),
        ),
        endian: Endian.little,
      ).toInt(),
    );
  }

  static ParsingResult<BigInt> _parseNumberOfTxInputs({
    @required Uint8List bytes,
    @required int currentByteIndex,
  }) {
    final numberOfBytes = Varint.numberOfNecessaryBytes(
      flag: bytes[currentByteIndex],
    );
    final numberOfTxInputs = Varint.read(
      bytes: Uint8List.fromList(
        bytes.sublist(currentByteIndex),
      ),
    );

    return ParsingResult(
      currentBytePosition: currentByteIndex + numberOfBytes + 1,
      result: numberOfTxInputs,
    );
  }

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
        txInVarintByteNumber ??= Varint.numberOfNecessaryBytes(flag: byte);

        if (txInVarintByteNumber == 0 ||
            acc.length == txInVarintByteNumber + 1) {
          txInVarint = Varint.read(bytes: Uint8List.fromList(acc));

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
