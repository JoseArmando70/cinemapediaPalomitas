import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Text('Cinemapedia', style: titleStyle),
              Spacer(),
              IconButton(
                onPressed: () {
                  //FUNCIONALIDAD: Navegar a pantalla de búsqueda
                  context.push('/search');
                },
                icon: Icon(Icons.search_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}