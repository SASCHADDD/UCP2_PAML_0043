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

class TambahKatalogPage extends StatefulWidget {
  const TambahKatalogPage({super.key});

  @override
  State<TambahKatalogPage> createState() => _TambahKatalogPageState();
}

class _TambahKatalogPageState extends State<TambahKatalogPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _platController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  String? _selectedKategoriId;
  String _selectedStatus = 'Tersedia';
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Ambil data kategori saat halaman dimuat
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
      
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih gambar terlebih dahulu!')),
        );
        return;
      }

      final data = {
        'id_kategori': _selectedKategoriId!,
        'nama_kendaraan': _namaController.text,
        'merk': _merkController.text,
        'tahun': _tahunController.text,
        'plat_nomor': _platController.text,
        'harga': _hargaController.text,
        'status': _selectedStatus,
      };

      context.read<KatalogBloc>().add(CreateKatalog(data, _selectedImage!));
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
        title: const Text('Tambah Mobil (Katalog)'),
      ),
      body: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mobil berhasil ditambahkan!')),
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

                // Pilih Gambar
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
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Pilih Gambar Mobil', style: TextStyle(color: Colors.grey)),
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
                      child: const Text('Simpan Data'),
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
