import 'dart:io';

import 'package:drive_ease/logic/bloc/katalog/katalog_bloc.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_event.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_state.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_bloc.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_event.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditKatalogPage extends StatefulWidget {
  final Map<String, dynamic> mobil;

  const EditKatalogPage({super.key, required this.mobil});

  @override
  State<EditKatalogPage> createState() => _EditKatalogPageState();
}

class _EditKatalogPageState extends State<EditKatalogPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _namaController;
  late TextEditingController _merkController;
  late TextEditingController _tahunController;
  late TextEditingController _platController;
  late TextEditingController _hargaController;

  String? _selectedKategoriId;
  String _selectedStatus = 'Tersedia';
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inisialisasi data awal
    _namaController = TextEditingController(text: widget.mobil['nama_kendaraan']?.toString() ?? '');
    _merkController = TextEditingController(text: widget.mobil['merk']?.toString() ?? '');
    _tahunController = TextEditingController(text: widget.mobil['tahun']?.toString() ?? '');
    _platController = TextEditingController(text: widget.mobil['plat_nomor']?.toString() ?? '');
    _hargaController = TextEditingController(text: widget.mobil['harga']?.toString() ?? '');
    
    _selectedKategoriId = widget.mobil['id_kategori']?.toString();
    
    // Pastikan status ada di list opsi
    final statusMap = {'tersedia': 'Tersedia', 'disewa': 'Disewa', 'perbaikan': 'Dalam Perawatan'};
    String initialStatus = widget.mobil['status']?.toString().toLowerCase() ?? 'tersedia';
    _selectedStatus = statusMap[initialStatus] ?? 'Tersedia';

    context.read<KategoriBloc>().add(FetchKategori());
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      if (_selectedKategoriId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih kategori terlebih dahulu!')),
        );
        return;
      }

      // Pastikan status yang dikirim sesuai dengan format database
      String statusDb;
      if (_selectedStatus == 'Tersedia') {
        statusDb = 'tersedia';
      } else if (_selectedStatus == 'Disewa') {
        statusDb = 'disewa';
      } else {
        statusDb = 'perbaikan';
      }

      final data = {
        'id_kategori': _selectedKategoriId!,
        'nama_kendaraan': _namaController.text,
        'merk': _merkController.text,
        'tahun': _tahunController.text,
        'plat_nomor': _platController.text,
        'harga': _hargaController.text,
        'status': statusDb,
      };

      final idKatalog = widget.mobil['id_katalog'].toString();
      
      // gambarBaru boleh null saat Update
      context.read<KatalogBloc>().add(UpdateKatalog(idKatalog, data, _selectedImage));
    }
  }

  void _showTambahKategoriDialog() {
    final TextEditingController kategoriController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori Baru'),
          content: TextField(
            controller: kategoriController,
            decoration: const InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (kategoriController.text.isNotEmpty) {
                  context.read<KategoriBloc>().add(CreateKategori(kategoriController.text));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kategori sedang ditambahkan...')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mobil (Katalog)'),
      ),
      body: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mobil berhasil diperbarui!')),
            );
            Navigator.pop(context); // Kembali ke halaman Home
          } else if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: _showTambahKategoriDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Kategori'),
                    ),
                  ],
                ),
                // Dropdown Kategori
                BlocBuilder<KategoriBloc, KategoriState>(
                  builder: (context, state) {
                    if (state is KategoriLoading || state is KategoriInitial || state is KategoriActionSuccess) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is KategoriLoaded) {
                      final kategoriList = state.kategoriList;
                      if (kategoriList.isEmpty) {
                        return const Text('Belum ada kategori, silakan tambah dulu.');
                      }
                      
                      // Pastikan selectedId ada dalam list
                      bool idExists = kategoriList.any((k) => k['id_kategori'].toString() == _selectedKategoriId);
                      if (!idExists) _selectedKategoriId = null;

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(hintText: 'Pilih Kategori'),
                        value: _selectedKategoriId,
                        items: kategoriList.map<DropdownMenuItem<String>>((kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori['id_kategori'].toString(),
                            child: Text(kategori['nama_kategori'] ?? 'Tanpa Nama'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedKategoriId = value;
                          });
                        },
                        validator: (value) => value == null ? 'Pilih Kategori' : null,
                      );
                    } else if (state is KategoriError) {
                      return Text('Gagal memuat kategori: ${state.message}', style: const TextStyle(color: Colors.red));
                    } else {
                      return const Text('Gagal memuat kategori');
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Nama Kendaraan
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Kendaraan'),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Merk
                TextFormField(
                  controller: _merkController,
                  decoration: const InputDecoration(labelText: 'Merk Kendaraan'),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Tahun
                TextFormField(
                  controller: _tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun Pembuatan'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Plat Nomor
                TextFormField(
                  controller: _platController,
                  decoration: const InputDecoration(labelText: 'Plat Nomor'),
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Harga
                TextFormField(
                  controller: _hargaController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Sewa',
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // Status
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Status'),
                  value: _selectedStatus,
                  items: ['Tersedia', 'Disewa', 'Dalam Perawatan']
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Pilih Gambar (Opsional untuk Edit)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : (widget.mobil['gambar'] != null && widget.mobil['gambar'].toString().isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.mobil['gambar'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50),
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Pilih Gambar Baru (Opsional)', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Simpan
                BlocBuilder<KatalogBloc, KatalogState>(
                  builder: (context, state) {
                    if (state is KatalogLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Simpan Perubahan'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _merkController.dispose();
    _tahunController.dispose();
    _platController.dispose();
    _hargaController.dispose();
    super.dispose();
  }
}
