import 'dart:async';
import 'package:cinemapedia/presentation/screens/movies/search_screen.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/movie/:id',
      name: MovieScreen.name,
      builder: (context, state) {
        final movieId = state.pathParameters['id'] ?? 'no-id';
        return MovieScreen(movieId: movieId);
      },
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => RegisterScreen(),
    ),
     GoRoute(
      path: '/search',
      name: SearchScreen.name,
      builder: (context, state) => SearchScreen(),
    ),
  ],


  
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthenticated = user != null;
    final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register';
    
    // Si NO está autenticado y NO está en una ruta de auth -> redirigir a login
    if (!isAuthenticated && !isAuthRoute) {
      return '/login';
    }
    
    // Si ESTÁ autenticado y ESTÁ en una ruta de auth -> redirigir a home
    if (isAuthenticated && isAuthRoute) {
      return '/';
    }
    
    // No redirigir en otros casos
    return null;
  },
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()) as Listenable,
);

// Clase helper para escuchar cambios en el estado de autenticación
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}