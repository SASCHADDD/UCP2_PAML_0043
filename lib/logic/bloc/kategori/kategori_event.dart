import 'package:equatable/equatable.dart';

abstract class KategoriEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event untuk mengambil daftar kategori
class FetchKategori extends KategoriEvent {}

// Event untuk menambah kategori baru
class CreateKategori extends KategoriEvent {
  final String namaKategori;
  
  CreateKategori(this.namaKategori);

  @override
  List<Object?> get props => [namaKategori];
}

// Event untuk mengedit kategori
class UpdateKategori extends KategoriEvent {
  final String idKategori;
  final String namaKategoriBaru;

  UpdateKategori(this.idKategori, this.namaKategoriBaru);

  @override
  List<Object?> get props => [idKategori, namaKategoriBaru];
}

// Event untuk menghapus kategori
class DeleteKategori extends KategoriEvent {
  final String idKategori;
  
  DeleteKategori(this.idKategori);

  @override
  List<Object?> get props => [idKategori];
}