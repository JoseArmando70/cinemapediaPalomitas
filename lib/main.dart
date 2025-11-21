import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/firebase_options.dart';
import 'package:cinemapedia/presentation/providers/auth/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  await dotenv.load(fileName: ".env");

  //  Inicialización de Firebase 
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("✅ Firebase inicializado correctamente");
    } else {
      print("ℹ️ Firebase ya estaba inicializado");
    }
  } catch (e) {
    // Si falla 
    print("⚠️ Error controlado de Firebase (La app continuará): $e");
  }

  //  Arrancar la App
  runApp(
    const ProviderScope(child: MainApp())
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      builder: (context, child) {
        return authState.when(
          data: (user) {
            return child!;
          },
          loading: () => Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          ),
        );
      },
    );
  }
}

// Prueba de git