import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class KatalogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchKatalog extends KatalogEvent {}

class CreateKatalog extends KatalogEvent {
  final Map<String, String> data;
  final File gambar;

  CreateKatalog(this.data, this.gambar);

  @override
  List<Object?> get props => [data, gambar];
}

class UpdateKatalog extends KatalogEvent {
  final String id;
  final Map<String, String> data;
  final File? gambarBaru;

  UpdateKatalog(this.id, this.data, this.gambarBaru);

  @override
  List<Object?> get props => [id, data, gambarBaru];
}

class DeleteKatalog extends KatalogEvent {
  final String id;
  DeleteKatalog(this.id);

  @override
  List<Object?> get props => [id];
}