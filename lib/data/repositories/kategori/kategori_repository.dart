import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class KategoriRepository {
  final String baseUrl = "http://127.0.0.1:3000/api/kategori"; 
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // --- GET ALL KATEGORI ---
  Future<List<dynamic>> getKategori() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token', // Tergantung apakah backendmu minta token untuk GET
          'Accept': 'application/json',
        },
      );

      developer.log('Response Get Kategori: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal mengambil data kategori';
      }
    } catch (e) {
      developer.log('Error pada Get Kategori: $e', name: 'API');
      rethrow;
    }
  }

  // --- CREATE KATEGORI ---
  Future<void> createKategori(String namaKategori) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'nama_kategori': namaKategori}), // Sesuaikan field dengan backend
      );

      developer.log('Response Create Kategori: ${response.body}', name: 'API');

      if (response.statusCode != 201 && response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal menambahkan kategori';
      }
    } catch (e) {
      developer.log('Error pada Create Kategori: $e', name: 'API');
      rethrow;
    }
  }

  // --- UPDATE KATEGORI ---
  Future<void> updateKategori(String idKategori, String namaKategoriBaru) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/$idKategori'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'nama_kategori': namaKategoriBaru}),
      );

      developer.log('Response Update Kategori: ${response.body}', name: 'API');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal mengupdate kategori';
      }
    } catch (e) {
      developer.log('Error pada Update Kategori: $e', name: 'API');
      rethrow;
    }
  }

  // --- DELETE KATEGORI ---
  Future<void> deleteKategori(String idKategori) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/$idKategori'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log('Response Delete Kategori: ${response.body}', name: 'API');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal menghapus kategori';
      }
    } catch (e) {
      developer.log('Error pada Delete Kategori: $e', name: 'API');
      rethrow;
    }
  }
}