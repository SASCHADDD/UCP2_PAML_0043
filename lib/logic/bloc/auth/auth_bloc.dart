import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/providers/storage_provider.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final StorageProvider storageProvider = StorageProvider();

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    
    // PROSES LOGIN
    on<LoginProcess>((event, emit) async {
      emit(AuthLoading());
      try {
        // Panggil repository untuk login ke API Express
        final user = await authRepository.login(event.email, event.password);        
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

      on<RegisterProcess>((event, emit) async {
      emit(AuthLoading());
      try {
        // Panggil fungsi register dari repository
        await authRepository.register(event.nama, event.email, event.password);
        // Jika berhasil, kirim state sukses agar UI bisa pindah ke halaman login
        emit(AuthRegisterSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // PROSES LOGOUT
    on<LogoutProcess>((event, emit) async {
      emit(AuthLoading());
      try {
        // Hapus token dari local storage agar user tidak bisa akses API lagi
        await storageProvider.deleteToken();
        emit(AuthLogoutSuccess());
      } catch (e) {
        emit(AuthError("Gagal Logout: $e"));
      }
    });
  }
}