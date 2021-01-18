import 'dart:typed_data';

import 'package:dartcoin/src/transaction/transaction.dart';
import 'package:dartcoin/src/transaction/transaction_input.dart';
import 'package:dartcoin/src/transaction/transaction_input_factory.dart';
import 'package:dartcoin/src/transaction/transaction_output.dart';
import 'package:dartcoin/src/transaction/transaction_output_factory.dart';
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

class TransactionFactory {
  static Transaction parseSync({
    @required Uint8List bytes,
    int initialIndex = 0,
    bool testnet = true,
  }) {
    final versionResult = _parseVersion(
      bytes: bytes,
      initialIndex: initialIndex,
    );
    initialIndex = versionResult.currentBytePosition;
    final version = versionResult.result;

    final numberOfTxInputsResult = _parseNumberOfTxInputs(
      bytes: bytes,
      initialIndex: initialIndex,
    );
    initialIndex = numberOfTxInputsResult.currentBytePosition;
    final numberOfTxInputs = numberOfTxInputsResult.result;

    final txIns = <TxInput>[];
    for (var i = 0; i < numberOfTxInputs.toInt(); i++) {
      final txInResult = TxInputFactory.parseSync(
        bytes: bytes,
        initialIndex: initialIndex,
      );
      initialIndex = txInResult.currentBytePosition;

      txIns.add(txInResult.result);
    }

    final numberOfTxOutputsResult = _parseNumberOfTxOutputs(
      bytes: bytes,
      initialIndex: initialIndex,
    );
    initialIndex = numberOfTxOutputsResult.currentBytePosition;
    final numberOfTxOutputs = numberOfTxOutputsResult.result;

    final txOuts = <TxOutput>[];
    for (var i = 0; i < numberOfTxOutputs.toInt(); i++) {
      final txOutResult = TxOutputFactory.parseSync(
        bytes: bytes,
        initialIndex: initialIndex,
      );
      initialIndex = txOutResult.currentBytePosition;

      txOuts.add(txOutResult.result);
    }

    final locktimeResult = _parseLocktime(
      bytes: bytes,
      initialIndex: initialIndex,
    );
    initialIndex = locktimeResult.currentBytePosition;
    final locktime = locktimeResult.result;

    return Transaction(
      locktime: locktime,
      testnet: testnet,
      txIns: txIns,
      txOuts: txOuts,
      version: version,
    );
  }

  static ParsingResult<BigInt> _parseVersion({
    @required Uint8List bytes,
    @required int initialIndex,
  }) {
    return ParsingResult(
      currentBytePosition: initialIndex + 4,
      result: ObjectUtils.bytesToBigInt(
        bytes: Uint8List.fromList(
          bytes.sublist(initialIndex, initialIndex + 4),
        ),
        endian: Endian.little,
      ),
    );
  }

  static ParsingResult<BigInt> _parseNumberOfTxInputs({
    @required Uint8List bytes,
    @required int initialIndex,
  }) {
    final numberOfBytes = Varint.numberOfNecessaryBytes(
      flag: bytes[initialIndex],
    );
    final numberOfTxInputs = Varint.read(
      bytes: Uint8List.fromList(
        bytes.sublist(initialIndex),
      ),
    );

    return ParsingResult(
      currentBytePosition: initialIndex + numberOfBytes + 1,
      result: numberOfTxInputs,
    );
  }

  static ParsingResult<BigInt> _parseNumberOfTxOutputs({
    @required Uint8List bytes,
    @required int initialIndex,
  }) {
    final numberOfBytes = Varint.numberOfNecessaryBytes(
      flag: bytes[initialIndex],
    );
    final numberOfTxOutputs = Varint.read(
      bytes: Uint8List.fromList(
        bytes.sublist(initialIndex),
      ),
    );

    return ParsingResult(
      currentBytePosition: initialIndex + numberOfBytes + 1,
      result: numberOfTxOutputs,
    );
  }

  static ParsingResult<BigInt> _parseLocktime({
    @required Uint8List bytes,
    @required int initialIndex,
  }) {
    final locktime = ObjectUtils.bytesToBigInt(
      bytes: Uint8List.fromList(
        bytes.sublist(
          initialIndex,
          initialIndex + 4,
        ),
      ),
      endian: Endian.little,
    );

    return ParsingResult(
      currentBytePosition: initialIndex + 4,
      result: locktime,
    );
  }
}
