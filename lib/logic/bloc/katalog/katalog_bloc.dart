import 'package:drive_ease/data/repositories/katalog/katalog_repository.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_event.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final KatalogRepository repository;

  KatalogBloc({required this.repository}) : super(KatalogInitial()) {
    
    on<FetchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final list = await repository.getKatalog();
        emit(KatalogLoaded(list));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<CreateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.createKatalog(event.data, event.gambar);
        emit(KatalogActionSuccess());
        add(FetchKatalog()); 
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<UpdateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.updateKatalog(event.id, event.data, event.gambarBaru);
        emit(KatalogActionSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<DeleteKatalog>((event, emit) async {
      try {
        await repository.deleteKatalog(event.id);
        emit(KatalogActionSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });
  }
}