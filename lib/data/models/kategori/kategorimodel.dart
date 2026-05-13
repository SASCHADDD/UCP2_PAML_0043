class KategoriModel {
  final String idKategori;
  final String namaKategori;

  KategoriModel({
    required this.idKategori, 
    required this.namaKategori
    });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'],
    );
  }
}