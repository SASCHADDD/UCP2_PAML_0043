import 'package:equatable/equatable.dart';

abstract class KategoriState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KategoriInitial extends KategoriState {}
class KategoriLoading extends KategoriState {}

// State ketika data berhasil diambil
class KategoriLoaded extends KategoriState {
  final List<dynamic> kategoriList;
  
  KategoriLoaded(this.kategoriList);

  @override
  List<Object?> get props => [kategoriList];
}

// State ketika terjadi error
class KategoriError extends KategoriState {
  final String message;
  
  KategoriError(this.message);

  @override
  List<Object?> get props => [message];
}

// State pemberitahuan saat proses Create/Update/Delete berhasil
class KategoriActionSuccess extends KategoriState {}