import 'dart:typed_data';

import 'package:dartcoin/src/utils/object_utils.dart';
import 'package:meta/meta.dart';

enum HashType {
  sigHashAll,
  sigHashNone,
  sigHashSingle,
}

class TransactionUtils {
  static final _hashTypeMap = <HashType, BigInt>{
    HashType.sigHashAll: BigInt.one,
    HashType.sigHashNone: BigInt.two,
    HashType.sigHashSingle: BigInt.from(3),
  };

  static Uint8List hashTypeBytes({@required HashType hashType}) =>
      ObjectUtils.bigIntToBytes(
        number: _hashTypeMap[hashType],
        endian: Endian.little,
        size: 4,
      );

  static BigInt hashTypeValue({@required HashType hashType}) =>
      _hashTypeMap[hashType];
}
