# Fuse Wallet

[![License](https://img.shields.io/badge/License-MIT-lightgrey)](https://img.shields.io/badge/License-MIT-lightgrey)

The Fuse wallet is a cross platform Ethereum wallet written in Dart and built on [Flutter](http://https://flutter.dev/). It's runninng on to the Fuse network, but can be plugged into any EVM compatible blockchain.

The app interacts with the Ethereum network using the [dart-web3.0 package](https://pub.dev/packages/web3dart), and the user signs the transaction with the private key which is User encrypted locally on the device. The controll of the data stays in user hands, it is managed in a decentralised mannger via 3box and IPFS protocol. Fuse wallet is meant to be used with the Fuse Studio and can integrate any ERC-20 token by changing the default contract address.

Fuse wallet is using Redux for state-management, it is easily customizable and allows localization easily. Check out our translation progress and feel free to help with transaltion trough [Lokalize](https://lokalise.co/public/783082135d36f14996c804.53212944/)


