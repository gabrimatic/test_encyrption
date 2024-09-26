// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';

/// Entry point of the Flutter application.
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption Tests',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const EncryptionTestScreen(),
    );
  }
}

/// A stateful widget that provides encryption testing functionalities.
class EncryptionTestScreen extends StatefulWidget {
  const EncryptionTestScreen({super.key});

  @override
  _EncryptionTestScreenState createState() => _EncryptionTestScreenState();
}

/// State class for [EncryptionTestScreen] handling UI and encryption logic.
class _EncryptionTestScreenState extends State<EncryptionTestScreen> {
  // Instance of FlutterSecureStorage for secure data storage.
  final storage = const FlutterSecureStorage();

  // Variable to store and display the result of encryption tests.
  String _result = '';

  // Controller for the text input field.
  final TextEditingController _textController = TextEditingController();

  // Key to manage form validation state.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Tests AES encryption and decryption on the input text.
  Future<void> testAES() async {
    if (!_formKey.currentState!.validate()) return;

    // Generate a random 32-byte AES key and a 16-byte IV.
    final key = encrypt.Key.fromSecureRandom(32);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final plainText = _textController.text;
    // Encrypt the plaintext.
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // Decrypt the ciphertext.
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    // Update the UI with the encryption results.
    setState(() {
      _result =
          '🔒 **AES Test**\n\n**Original**: $plainText\n\n**Encrypted**: ${encrypted.base64}\n\n**Decrypted**: $decrypted\n\n**Key**: ${key.base64}\n\n**IV**: ${iv.base64}';
    });
  }

  /// Tests RSA encryption and decryption on the input text.
  Future<void> testRSA() async {
    if (!_formKey.currentState!.validate()) return;

    // Generate an RSA key pair with a specified bit length.
    final keyPair = await generateRSAkeyPair(2048);
    final publicKey = keyPair.publicKey as RSAPublicKey;
    final privateKey = keyPair.privateKey as RSAPrivateKey;

    final plainText = _textController.text;
    // Encrypt the plaintext using the public key.
    final encrypted = rsaEncrypt(publicKey, plainText);
    // Decrypt the ciphertext using the private key.
    final decrypted = rsaDecrypt(privateKey, encrypted);

    // Update the UI with the encryption results.
    setState(() {
      _result =
          '🔒 **RSA Test**\n\n**Original**: $plainText\n\n**Encrypted**: ${base64Encode(encrypted)}\n\n**Decrypted**: $decrypted\n\n**Public Key**: \n$publicKey\n\n**Private Key**: \n$privateKey';
    });
  }

  /// Tests storing and retrieving data securely using Flutter Secure Storage.
  Future<void> testSecureStorage() async {
    if (!_formKey.currentState!.validate()) return;

    final valueToStore = _textController.text;
    // Write the value to secure storage with a specific key.
    await storage.write(key: 'testKey', value: valueToStore);
    // Read the value back from secure storage.
    final value = await storage.read(key: 'testKey');

    // Update the UI with the storage results.
    setState(() {
      _result =
          '🔒 **Secure Storage Test**\n\n**Stored Value**: $value\n\n**Key Used**: testKey';
    });
  }

  /// Resets the input field and clears the result display.
  void resetFields() {
    _textController.clear();
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption Tests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetFields,
            tooltip: 'Reset Fields',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Form for user input with validation.
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Enter text to encrypt',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            // Buttons to trigger different encryption tests.
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: testAES,
                  icon: const Icon(Icons.vpn_key),
                  label: const Text('Test AES'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: testRSA,
                  icon: const Icon(Icons.lock),
                  label: const Text('Test RSA'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: testSecureStorage,
                  icon: const Icon(Icons.security),
                  label: const Text('Test Secure Storage'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: resetFields,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Display the result of the encryption test if available.
            if (_result.isNotEmpty)
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: _result,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Generates an RSA key pair with the specified [bitLength].
///
/// Utilizes a secure random number generator and initializes the RSA key generator.
///
/// Returns an [AsymmetricKeyPair] containing the public and private keys.
Future<AsymmetricKeyPair<PublicKey, PrivateKey>> generateRSAkeyPair(
    int bitLength) async {
  // Create a secure random number generator.
  final secureRandom = FortunaRandom();

  // Seed the random number generator with 32 random bytes (256 bits).
  final seedSource = math.Random.secure();
  final seeds = List<int>.generate(32, (_) => seedSource.nextInt(256));
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

  // Initialize the RSA key generator with the specified parameters.
  final keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        secureRandom));

  // Generate and return the key pair.
  return keyGen.generateKeyPair();
}

/// Encrypts the [plaintext] using the provided [publicKey] with RSA.
///
/// Returns the encrypted data as a [Uint8List].
Uint8List rsaEncrypt(RSAPublicKey publicKey, String plaintext) {
  final encryptor = RSAEngine()
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

  final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
  return _processInBlocks(encryptor, plaintextBytes);
}

/// Decrypts the [ciphertext] using the provided [privateKey] with RSA.
///
/// Returns the decrypted plaintext as a [String].
String rsaDecrypt(RSAPrivateKey privateKey, Uint8List ciphertext) {
  final decryptor = RSAEngine()
    ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

  final decryptedBytes = _processInBlocks(decryptor, ciphertext);
  return utf8.decode(decryptedBytes);
}

/// Helper function to process data in blocks for RSA encryption/decryption.
///
/// It ensures that the data is processed according to the block size of the RSA engine.
///
/// Returns the processed data as a [Uint8List].
Uint8List _processInBlocks(RSAEngine engine, Uint8List input) {
  final numBlocks = (input.length / engine.inputBlockSize).ceil();
  final output = <int>[];

  for (var i = 0; i < numBlocks; i++) {
    final start = i * engine.inputBlockSize;
    final end = math.min(start + engine.inputBlockSize, input.length);
    final block = input.sublist(start, end);
    final processed = engine.process(block);
    output.addAll(processed);
  }

  return Uint8List.fromList(output);
}
