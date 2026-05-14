import 'package:drive_ease/data/repositories/kategori/kategori_repository.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_event.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  KategoriBloc({required this.repository}) : super(KategoriInitial()) {
    
    // READ: Ambil Semua Kategori
    on<FetchKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        final listData = await repository.getKategori();
        emit(KategoriLoaded(listData));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    // CREATE: Tambah Kategori Baru
    on<CreateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.createKategori(event.namaKategori);
        emit(KategoriActionSuccess());
        add(FetchKategori()); // Refresh list otomatis
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    // UPDATE: Edit Kategori
    on<UpdateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.updateKategori(event.idKategori, event.namaKategoriBaru);
        emit(KategoriActionSuccess());
        add(FetchKategori()); // Refresh list otomatis
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    // DELETE: Hapus Kategori
    on<DeleteKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.deleteKategori(event.idKategori);
        emit(KategoriActionSuccess());
        add(FetchKategori()); // Refresh list otomatis
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });
  }
}