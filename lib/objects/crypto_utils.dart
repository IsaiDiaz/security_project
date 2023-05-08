import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

final key = Key.fromSecureRandom(32);
final iv = IV.fromSecureRandom(16);
final encrypter = Encrypter(AES(key));

class CryptoUtils{

  static encrypt(message){
    return encrypter.encrypt(message, iv: iv);
  }

  static String decrypt(encrypted){
    return encrypter.decrypt(encrypted, iv: iv);
  }

}
