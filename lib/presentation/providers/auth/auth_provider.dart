import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';


final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});


class AuthState {
  final bool isLoading;
  final String? errorMessage;

  AuthState({this.isLoading = false, this.errorMessage});

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // --- LOGIN CON GOOGLE ---
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // cancela el login
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Obtiene los tokens de seguridad
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Crea la credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      state = state.copyWith(isLoading: false);

      if (context.mounted) {
        context.go('/');
      }

    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Error al iniciar con Google',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado: $e',
      );
    }
  }

  // --- LOGIN CON EMAIL ---
  Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      
      if (context.mounted) {
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e.code),
      );
    }
  }

  // --- REGISTRO ---
  Future<void> signUpWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      
      if (context.mounted) {
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getErrorMessage(e.code),
      );
    }
  }

  // --- CERRAR SESIÓN ---
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      // Cierra también la sesión de Google
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  // Helper para mensajes de error
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'Usuario no encontrado';
      case 'wrong-password': return 'Contraseña incorrecta';
      case 'email-already-in-use': return 'El email ya está registrado';
      case 'weak-password': return 'La contraseña es muy débil';
      case 'invalid-email': return 'Email inválido';
      default: return 'Error de autenticación';
    }
  }
}