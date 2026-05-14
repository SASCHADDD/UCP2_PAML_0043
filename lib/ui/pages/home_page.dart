import 'package:drive_ease/data/repositories/auth/auth_repository.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_bloc.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_event.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_state.dart';
import 'package:drive_ease/ui/pages/login_page.dart';
import 'package:drive_ease/ui/pages/tambahkatalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Langsung ambil data katalog saat halaman pertama kali dibuka
    context.read<KatalogBloc>().add(FetchKatalog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DriveEase Katalog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<KatalogBloc>().add(FetchKatalog()),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await RepositoryProvider.of<AuthRepository>(context).logout();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
                ); // Gunakan ";" untuk menutup fungsi Navigator
              } // Penutup blok if
            }, // Penutup onPressed
          ),
        ],
      ),
      body: BlocBuilder<KatalogBloc, KatalogState>(
        builder: (context, state) {
          if (state is KatalogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KatalogLoaded) {
            final mobilList = state.katalogList;

            if (mobilList.isEmpty) {
              return const Center(child: Text("Belum ada data mobil."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mobilList.length,
              itemBuilder: (context, index) {
                final mobil = mobilList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),        
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          mobil['gambar'] != null && mobil['gambar'].toString().isNotEmpty ? mobil['gambar'] : 'https://via.placeholder.com/200',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, size: 50),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mobil['nama_kendaraan'] ?? 'Tanpa Nama',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Harga: Rp ${mobil['harga'] ?? '0'}",
                              style: TextStyle(color: Colors.blue[700], fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${mobil['merk'] ?? ''} - ${mobil['tahun'] ?? ''} | Plat: ${mobil['plat_nomor'] ?? ''}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is KatalogError) {
            return Center(
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}", textAlign: TextAlign.center),
                  ElevatedButton(
                    onPressed: () => context.read<KatalogBloc>().add(FetchKatalog()),
                    child: const Text("Coba Lagi"),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text("Memulai..."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKatalogPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}