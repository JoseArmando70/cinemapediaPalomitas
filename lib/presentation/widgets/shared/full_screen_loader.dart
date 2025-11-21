import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = [
      'Cargando películas...',
      'Comprando palomitas...',
      'Cargando populares...',
      'Comiendo una Maruchan...',
      'Ya mero...',
      'Esto está tomando más tiempo de lo esperado...',
    ];

    return Stream.periodic(Duration(milliseconds: 1200), (step) {
      return messages[step % messages.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 8,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                backgroundColor: colors.primary.withOpacity(0.2),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Espera un momento...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onBackground,
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: getLoadingMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Cargando...');
                }
                return Text(
                  snapshot.data!,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.onBackground.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}