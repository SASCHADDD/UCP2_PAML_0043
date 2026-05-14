import 'package:equatable/equatable.dart';

abstract class KatalogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KatalogInitial extends KatalogState {}
class KatalogLoading extends KatalogState {}

class KatalogLoaded extends KatalogState {
  final List<dynamic> katalogList;
  KatalogLoaded(this.katalogList);

  @override
  List<Object?> get props => [katalogList];
}

class KatalogError extends KatalogState {
  final String message;
  KatalogError(this.message);

  @override
  List<Object?> get props => [message];
}

class KatalogActionSuccess extends KatalogState {}