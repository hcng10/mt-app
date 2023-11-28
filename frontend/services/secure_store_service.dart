import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../macro/constant.dart';

// TODO: only support web for now

class SecureStoreService {
  // Create storage
  final storage = const FlutterSecureStorage();

  final String _keyUserEmail = 'useremail';
  final String _keyPassword = 'password';
  final String _keySavedPhoneDetail = 'savedphone';

  Future setUserEmail(String userEmail) async {
    await storage.write(key: _keyUserEmail, value: userEmail);
  }

  Future<String?> getUserEmail() async {
    return await storage.read(key: _keyUserEmail);
  }

  Future setPassword(String password) async {
    await storage.write(key: _keyPassword, value: password);
  }

  Future<String?> getPassword() async {
    return await storage.read(key: _keyPassword);
  }

  Future setSavedPhoneDetail(String phonedetail) async {
    await storage.write(key: _keySavedPhoneDetail, value: phonedetail);
  }

  Future<String?> getSavedPhoneDetail() async {
    return await storage.read(key: _keySavedPhoneDetail);
  }

}