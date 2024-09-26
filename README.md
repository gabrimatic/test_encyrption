# Flutter Encryption Demo

![Flutter](https://img.shields.io/badge/Flutter-v3.10.5-blue.svg)
![Dart](https://img.shields.io/badge/Dart-v2.19.4-blue.svg)
![MIT License](https://img.shields.io/badge/License-MIT-green.svg)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Technical Details](#technical-details)
  - [Architecture](#architecture)
  - [Encryption Methods](#encryption-methods)
  - [Secure Storage](#secure-storage)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Overview

The **Flutter Encryption Demo** is a Flutter-based mobile application designed to demonstrate fundamental encryption techniques, including AES (Advanced Encryption Standard) and RSA (Rivest–Shamir–Adleman) encryption. Additionally, it showcases secure data storage using Flutter's secure storage solutions. This project serves as an educational tool for developers to understand and implement encryption and secure storage in Flutter applications.

## Features

- **AES Encryption & Decryption**: Encrypt and decrypt user-provided text using AES with randomly generated keys and initialization vectors (IV).
- **RSA Encryption & Decryption**: Generate RSA key pairs, encrypt plaintext with the public key, and decrypt ciphertext with the private key.
- **Secure Storage**: Store and retrieve sensitive data securely using Flutter Secure Storage.
- **User-Friendly Interface**: Intuitive UI with input validation, clear result displays, and easy-to-use buttons for testing encryption methods.
- **Result Visualization**: Display encryption results, keys, and stored values in a readable Markdown format.

## Getting Started

### Prerequisites

- **Flutter SDK**: Ensure you have Flutter installed. If not, follow the [official installation guide](https://flutter.dev/docs/get-started/install).
- **Dart SDK**: Included with Flutter.
- **Development Environment**: An IDE such as [Android Studio](https://developer.android.com/studio), [VS Code](https://code.visualstudio.com/), or [IntelliJ IDEA](https://www.jetbrains.com/idea/).

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/flutter_encryption_demo.git
   cd flutter_encryption_demo
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the Application**

   - **Using Terminal**

     ```bash
     flutter run
     ```

   - **Using IDE**

     - Open the project in your preferred IDE.
     - Select the target device.
     - Click on the **Run** button.

## Usage

1. **Enter Text**: Input the text you wish to encrypt in the provided text field.
2. **Select Encryption Method**:
   - **Test AES**: Encrypt and decrypt the text using AES. View the original text, encrypted data, decrypted text, AES key, and IV.
   - **Test RSA**: Encrypt and decrypt the text using RSA. View the original text, encrypted data, decrypted text, public key, and private key.
   - **Test Secure Storage**: Store the input text securely and retrieve it to ensure data integrity.
3. **Reset Fields**: Clear the input and results to start a new test.
4. **View Results**: Encryption results and keys are displayed in a formatted Markdown card for easy readability.

## Technical Details

### Architecture

The application follows a straightforward Flutter architecture with the following components:

- **Main Entry Point**: Initializes and runs the `MyApp` widget.
- **MyApp Widget**: Sets up the MaterialApp with theming and routes to the `EncryptionTestScreen`.
- **EncryptionTestScreen**: A stateful widget that handles user interactions, encryption logic, and result display.

### Encryption Methods

1. **AES (Advanced Encryption Standard)**
   - **Key Generation**: Generates a 32-byte (256-bit) random key.
   - **IV Generation**: Generates a 16-byte (128-bit) random Initialization Vector.
   - **Encryption**: Uses the `encrypt` package to perform AES encryption.
   - **Decryption**: Decrypts the ciphertext back to plaintext using the same key and IV.

2. **RSA (Rivest–Shamir–Adleman)**
   - **Key Pair Generation**: Utilizes the `pointycastle` library to generate a 2048-bit RSA key pair.
   - **Encryption**: Encrypts plaintext using the RSA public key.
   - **Decryption**: Decrypts ciphertext using the RSA private key.
   - **Block Processing**: Handles data in blocks to accommodate RSA's block size limitations.

### Secure Storage

- **Flutter Secure Storage**: Implements secure storage using the `flutter_secure_storage` package, which leverages platform-specific secure storage solutions (Keychain for iOS and Keystore for Android).
- **Data Handling**: Stores and retrieves user-provided text securely, ensuring data confidentiality.

## Dependencies

The project relies on several Dart and Flutter packages to provide encryption and secure storage functionalities:

- **Core Packages**
  - `flutter`: SDK for building Flutter applications.
  - `dart:convert`, `dart:math`, `dart:typed_data`: Dart core libraries for data handling.

- **Encryption Packages**
  - [`encrypt`](https://pub.dev/packages/encrypt): Simplifies AES encryption and decryption.
  - [`pointycastle`](https://pub.dev/packages/pointycastle): Provides cryptographic algorithms, including RSA.

- **UI Packages**
  - [`flutter_markdown`](https://pub.dev/packages/flutter_markdown): Renders Markdown formatted text.
  - [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage): Facilitates secure data storage.

- **State Management**
  - No external state management libraries are used; the app relies on Flutter's built-in `StatefulWidget` and `setState`.

**Pubspec.yaml Dependencies Section:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  encrypt: ^5.0.1
  pointycastle: ^3.6.1
  flutter_markdown: ^0.6.10
  flutter_secure_storage: ^8.0.0
```

## License

This project is licensed under the [MIT License](LICENSE).

---

**Note**: This project is intended for educational purposes. Ensure that you handle encryption keys and sensitive data securely in production environments.

# Acknowledgements

- [Flutter](https://flutter.dev/)
- [Encrypt Package](https://pub.dev/packages/encrypt)
- [PointyCastle](https://pub.dev/packages/pointycastle)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Flutter Markdown](https://pub.dev/packages/flutter_markdown)


---

© 2024 [Hossein Yousefpour](https://github.com/gabrimatic)