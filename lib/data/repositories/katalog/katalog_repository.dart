import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class KatalogRepository {
  final String baseUrl = "http://127.0.0.1:3000/api/katalog";
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // --- Ambil Semua Data Katalog ---
  Future<List<dynamic>> getKatalog() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      developer.log('Response Get Katalog: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal mengambil data katalog';
      }
    } catch (e) {
      developer.log('Error pada Get Katalog: $e', name: 'API');
      rethrow;
    }
  }

  // --- Tambah Katalog Baru (Dengan Upload Gambar) ---
  Future<void> createKatalog(Map<String, String> fields, File gambarFile) async {
    try {
      final token = await _getToken();
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      // Menambahkan Header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Menambahkan field teks (nama_kendaraan, harga, dll)
      request.fields.addAll(fields);

      // Menambahkan file gambar fisik
      request.files.add(await http.MultipartFile.fromPath(
        'gambar', 
        gambarFile.path
      ));

      // Mengirim request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      developer.log('Response Create Katalog: ${response.body}', name: 'API');

      if (response.statusCode != 201 && response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal menambahkan data mobil';
      }
    } catch (e) {
      developer.log('Error pada Create Katalog: $e', name: 'API');
      rethrow;
    }
  }

  // --- Update Katalog (Gambar Opsional) ---
  Future<void> updateKatalog(String idKatalog, Map<String, String> fields, File? gambarBaru) async {
    try {
      final token = await _getToken();
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$idKatalog'));

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields.addAll(fields);

      // Hanya tambahkan file jika user memilih gambar baru di UI
      if (gambarBaru != null) {
        request.files.add(await http.MultipartFile.fromPath('gambar', gambarBaru.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      developer.log('Response Update Katalog: ${response.body}', name: 'API');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal memperbarui data mobil';
      }
    } catch (e) {
      developer.log('Error pada Update Katalog: $e', name: 'API');
      rethrow;
    }
  }

  // --- Hapus Katalog ---
  Future<void> deleteKatalog(String idKatalog) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/$idKatalog'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      developer.log('Response Delete Katalog: ${response.body}', name: 'API');

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Gagal menghapus data mobil';
      }
    } catch (e) {
      developer.log('Error pada Delete Katalog: $e', name: 'API');
      rethrow;
    }
  }
}