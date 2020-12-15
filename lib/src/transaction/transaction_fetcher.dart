import 'package:dartcoin/src/models/all.dart';
import 'package:dartcoin/src/transaction/all.dart';
import 'package:dartcoin/src/utils/all.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

abstract class TxFetcher {
  final Map<String, Transaction> cache = {};

  Future<Transaction> fetch({
    bool fresh = false,
    bool testnet = true,
    @required String hexTxId,
  }) async {
    if (fresh || !cache.containsKey(hexTxId)) {
      final url = '${urlToQuery(testnet: testnet)}/tx/$hexTxId/hex';
      final response = await get(url);

      if (response.statusCode != 200) {
        throw NetworkError(
          reasonPhrase: response.reasonPhrase,
          statusCode: response.statusCode,
        );
      }

      final rawTx = ObjectUtils.bigIntToBytes(
        number: BigInt.parse(
          response.body,
          radix: 16,
        ),
      );

      Transaction result;

      if (rawTx[4] == 0) {
        /// TODO: WHY IS THIS HANDLED SO DIFFERENTLY? https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch05/tx.py#L37
      } else {
        result = TransactionFactory.parseSync(
          bytes: rawTx,
          testnet: testnet,
        );
      }

      if (result.id != hexTxId) {
        throw ArgumentError('Not the same id: ${result.id} vs ${hexTxId}');
      }

      cache[hexTxId] = result;
    }

    return cache[hexTxId];
  }

  String urlToQuery({bool testnet = true});
}

class BitcoinTxFetcher extends TxFetcher {
  @override
  String urlToQuery({bool testnet = true}) {
    return testnet
        ? 'https://blockstream.info/testnet/api'
        : 'https://blockstream.info/api';
  }
}
