import 'dart:math';

import 'dart:typed_data';

import 'package:pointycastle/export.dart';

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
  // Initialize the secure random number generator
  final secureRandom = FortunaRandom();

  // Seed the generator
  final seedSource = Random.secure();

  final seeds = List<int>.generate(32, (_) => seedSource.nextInt(256));

  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

  // Set up key generation parameters
  final keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12),
      secureRandom,
    ));

  // Generate the key pair
  final pair = keyGen.generateKeyPair();

  final publicKey = pair.publicKey as RSAPublicKey;

  final privateKey = pair.privateKey as RSAPrivateKey;

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
}
