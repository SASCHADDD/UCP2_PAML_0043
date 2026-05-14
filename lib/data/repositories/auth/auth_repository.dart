import 'dart:convert';
import 'dart:developer' as developer;

import 'package:drive_ease/data/models/auth/authmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = "http://127.0.0.1:3000/api";
  final _storage = const FlutterSecureStorage();

  Future<void> persistToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }
  

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      developer.log('Response Login: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        if (data['user'] == null) {
          throw 'Format respons tidak valid: Data user tidak ditemukan';
        }
        if (data['token'] == null) {
          throw 'Format respons tidak valid: Token tidak ditemukan';
        }

        await persistToken(data['token']);
        return UserModel.fromJson(data['user']);
      } else {
        throw data['message'] ?? 'Gagal Login';
      }
    } catch (e) {
      developer.log('Error pada Login: $e', name: 'API');
      rethrow;
    }
  }
  Future<void> register(String nama, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? 'Gagal Register';
    }
  }

  Future<void> logout() async {
  try {
    // 1. Ambil token yang sedang aktif
    final token = await _storage.read(key: 'jwt_token');

    // 2. Panggil API logout di backend
    final response = await http.post(
      Uri.parse("$baseUrl/logout"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Kirim token agar server tahu siapa yang logout
      },
    );

    if (response.statusCode == 200) {
       print("Berhasil logout dari server");
    }
  } catch (e) {
    // Tetap lanjut hapus token lokal meskipun server gagal/offline
    print("Gagal panggil API logout: $e");
  } finally {
    // 3. Apapun yang terjadi, hapus token di lokal HP
    await deleteToken();
  }
}
}