import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/providers/auth/auth_provider.dart';

class CustomBottomnavigationbar extends ConsumerWidget {
  const CustomBottomnavigationbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authStateProvider);
        
        return authState.when(
          data: (user) {
            // Si el usuario está autenticado, mostrar el bottom navigation con perfil
            if (user != null) {
              return _AuthenticatedBottomBar();
            }
            // Si no está autenticado, mostrar bottom navigation básico
            return _UnauthenticatedBottomBar();
          },
          loading: () => SizedBox.shrink(),
          error: (error, stack) => _UnauthenticatedBottomBar(),
        );
      },
    );
  }
}

class _AuthenticatedBottomBar extends ConsumerWidget {
  const _AuthenticatedBottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurface.withOpacity(0.6),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max_outlined),
          activeIcon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          activeIcon: Icon(Icons.label),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Mi Perfil',
        ),
      ],
      onTap: (index) {
        if (index == 1) { // Índice de "Categorias"
          context.push('/categories');
        }
        if (index == 2) { 
        context.go('/favorites');
      }
        if (index == 3) { // Índice del item "Mi Perfil"
          _showProfileMenu(context, ref);
        }
      },
    );
  }

  void _showProfileMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Mi Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  // Aquí puedes navegar a una pantalla de perfil si la creas
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ajustes'),
                onTap: () {
                  Navigator.pop(context);
                  // Aquí puedes navegar a una pantalla de ajustes si la creas
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmation(context, ref);
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
              context.go('/login');
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

class _UnauthenticatedBottomBar extends StatelessWidget {
  const _UnauthenticatedBottomBar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurface.withOpacity(0.6),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max_outlined),
          activeIcon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          activeIcon: Icon(Icons.label),
          label: 'Categorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
      ],
    );
  }
}