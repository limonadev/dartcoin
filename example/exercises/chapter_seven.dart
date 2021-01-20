import 'dart:typed_data';

import 'package:dartcoin/dartcoin.dart';

class ChapterSeven {
  void runEverything({bool runOptionals = false}) async {
    print('Run each exercise from Chapter Seven');

    if (runOptionals) {
      print('Optional exercises');
      await _optionalFirst();
      _optionalSecond();
      _optionalThird();
      print('Optional Fourth Exercise');
      print(_optionalFourth());
      await _optionalFifth();
    }
  }

  /// Exercise 0.1 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch07/Chapter7.ipynb
  void _optionalFirst() async {
    print('Optional First Exercise');

    final rawTx = ObjectUtils.bytesFromHex(
      hex:
          '0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600',
    );
    final tx = TransactionFactory.parseSync(
      bytes: rawTx,
      testnet: false,
    );
    final fee = await tx.getFee();

    print(fee >= BigInt.zero);
  }

  /// Exercise 0.2 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch07/Chapter7.ipynb
  void _optionalSecond() {
    print('Optional Second Exercise');

    final sec = ObjectUtils.bytesFromHex(
      hex: '0349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278a',
    );
    final der = ObjectUtils.bytesFromHex(
      hex:
          '3045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed',
    );
    final z = BigInt.parse(
      '27e0c5994dec7824e56dec6b2fcb342eb7cdb0d0957c2fce9882f715e85d81a6',
      radix: 16,
    );
    final point = S256Point.fromSerialized(sec: sec);
    final signature = Signature.fromSerialized(der: der);
    print(
      point.verify(
        sig: signature,
        z: z,
      ),
    );
  }

  /// Exercise 0.3 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch07/Chapter7.ipynb
  void _optionalThird() {
    print('Optional Third Exercise');

    final modifiedTx = ObjectUtils.bytesFromHex(
      hex:
          '0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000001976a914a802fc56c704ce87c42d7c92eb75e7896bdc41ae88acfeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac1943060001000000',
    );
    final hashed = Secp256Utils.hash256(data: modifiedTx);
    final z = ObjectUtils.bytesToBigInt(bytes: hashed);
    print(
      ObjectUtils.toHex(value: z),
    );
  }

  /// Exercise 2.1 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch07/Chapter7.ipynb
  Transaction _optionalFourth() {
    final prevTxId = ObjectUtils.bytesFromHex(
      hex: '0d6fe5213c0b3291f208cba8bfb59b7476dffacc4e5cb66f6eb20a080843a299',
      endian: Endian.little,
    );
    final prevTxIndex = BigInt.from(13);
    final txIn = TxInput(
      prevTxId: prevTxId,
      prevTxIndex: prevTxIndex,
    );

    final changeAmount = BigInt.from((0.33 * 100000000).toInt());
    final changeHash160 = Base58Utils.decodeFromHumanReadable(
      humanReadable: 'mzx5YhAH9kNHtcN481u6WkjeHjYtVeKVh2',
    );
    final changeScript = ScriptFactory.buildP2pkhScript(
      hash160: changeHash160,
    );
    final changeOutput = TxOutput(
      amount: changeAmount,
      scriptPubkey: changeScript,
    );

    final targetAmount = BigInt.from((0.1 * 100000000).toInt());
    final targetHash160 = Base58Utils.decodeFromHumanReadable(
      humanReadable: 'mnrVtF8DWjMu839VW3rBfgYaAfKk8983Xf',
    );
    final targetScript = ScriptFactory.buildP2pkhScript(
      hash160: targetHash160,
    );
    final targetOutput = TxOutput(
      amount: targetAmount,
      scriptPubkey: targetScript,
    );

    final transaction = Transaction(
      txIns: [txIn],
      txOuts: [changeOutput, targetOutput],
      testnet: true,
      version: BigInt.one,
      locktime: BigInt.zero,
    );

    return transaction;
  }

  /// Exercise 2.2 from https://github.com/jimmysong/programmingbitcoin/blob/master/code-ch07/Chapter7.ipynb
  void _optionalFifth() async {
    print('Optional Fifth Exercise');

    var transaction = _optionalFourth();
    var z = await transaction.getSigHash(inputIndex: 0);
    final privateKey = PrivateKey(secret: BigInt.from(8675309));
    var der = privateKey.sign(z: z).der();
    var sig = Uint8List.fromList(<int>[
      ...der,
      ...ObjectUtils.bigIntToBytes(
        number: TransactionUtils.hashTypeValue(
          hashType: HashType.sigHashAll,
        ),
        endian: Endian.big,
        size: 1,
      ),
    ]);
    var sec = privateKey.point.sec();
    var scriptSig = Script(cmds: [sig, sec]);
    transaction.txIns[0] = transaction.txIns[0].copyWith(
      scriptSig: scriptSig,
    );

    var expected =
        '010000000199a24308080ab26e6fb65c4eccfadf76749bb5bfa8cb08f291320b3c21e56f0d0d0000006b4830450221008ed46aa2cf12d6d81065bfabe903670165b538f65ee9a3385e6327d80c66d3b502203124f804410527497329ec4715e18558082d489b218677bd029e7fa306a72236012103935581e52c354cd2f484fe8ed83af7a3097005b2f9c60bff71d35bd795f54b67ffffffff02408af701000000001976a914d52ad7ca9b3d096a38e752c2018e6fbc40cdf26f88ac80969800000000001976a914507b27411ccf7f16f10297de6cef3f291623eddf88ac00000000';
    var hexSerialized = ObjectUtils.bytesToHex(
      bytes: transaction.serialize(),
    );
    print(expected == hexSerialized);

    final rawTx = ObjectUtils.bytesFromHex(
      hex:
          '0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006b483045022100ed81ff192e75a3fd2304004dcadb746fa5e24c5031ccfcf21320b0277457c98f02207a986d955c6e0cb35d446a89d3f56100f4d7f67801c31967743a9c8e10615bed01210349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278afeffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600',
    );
    transaction = TransactionFactory.parseSync(
      bytes: rawTx,
      testnet: false,
    );

    z = await transaction.getSigHash(inputIndex: 0);
    der = privateKey.sign(z: z).der();
    sig = Uint8List.fromList(<int>[
      ...der,
      ...ObjectUtils.bigIntToBytes(
        number: TransactionUtils.hashTypeValue(
          hashType: HashType.sigHashAll,
        ),
        endian: Endian.big,
        size: 1,
      ),
    ]);
    sec = privateKey.point.sec();
    scriptSig = Script(cmds: [sig, sec]);
    transaction.txIns[0] = transaction.txIns[0].copyWith(
      scriptSig: scriptSig,
    );

    expected =
        '0100000001813f79011acb80925dfe69b3def355fe914bd1d96a3f5f71bf8303c6a989c7d1000000006a47304402207db2402a3311a3b845b038885e3dd889c08126a8570f26a844e3e4049c482a11022010178cdca4129eacbeab7c44648bf5ac1f9cac217cd609d216ec2ebc8d242c0a012103935581e52c354cd2f484fe8ed83af7a3097005b2f9c60bff71d35bd795f54b67feffffff02a135ef01000000001976a914bc3b654dca7e56b04dca18f2566cdaf02e8d9ada88ac99c39800000000001976a9141c4bc762dd5423e332166702cb75f40df79fea1288ac19430600';
    hexSerialized = ObjectUtils.bytesToHex(
      bytes: transaction.serialize(),
    );
    print(expected == hexSerialized);
  }
}
