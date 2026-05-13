class KatalogModel {
  final String idKatalog;
  final String namaKendaraan;
  final String merk;
  final String tahun;
  final String platNomor;
  final String harga;
  final String status;

  KatalogModel({
    required this.idKatalog,
    required this.namaKendaraan,
    required this.merk,
    required this.tahun,
    required this.platNomor,
    required this.harga,
    required this.status,
  });

  factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      idKatalog: json['id_katalog'],
      namaKendaraan: json['nama_kendaraan'], 
      merk: json['merk'],
      tahun: json['tahun'],
      platNomor: json ['platNomor'],
      harga: json ['harga'],
      status: json['status']
    );
  }
}
