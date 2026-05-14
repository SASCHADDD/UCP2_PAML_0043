import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String nama;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
    id: json['id']?.toString() ?? '',
    nama: json['nama'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? ''
     );
  }
  @override
  List<Object?> get props => [
    id, 
    nama,
    email,
    password
    ];
    
}