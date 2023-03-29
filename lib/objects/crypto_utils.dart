import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class CryptoUtils{

  static List<int> encrypt(String message){
    return utf8.encode(message);;
  }

  static String decrypt(List<int> encrypted){
    return utf8.decode(encrypted);
  }

}
