import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPlayerScreen extends StatefulWidget {
  final String videoId;

  const TrailerPlayerScreen({required this.videoId, super.key});

  @override
  State<TrailerPlayerScreen> createState() => _TrailerPlayerScreenState();
}

class _TrailerPlayerScreenState extends State<TrailerPlayerScreen> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Trailer"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CONTENEDOR CON ESTILO DEL VIDEO
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.redAccent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TÍTULO DEL VIDEO
            const Text(
              "Reproduciendo Trailer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // DESCRIPCIÓN / SUBTÍTULO
            Text(
              "Disfruta un avance oficial en alta calidad directamente desde YouTube.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // BOTÓN PARA ABRIR EN YOUTUBE DIRECTAMENTE
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final url = "https://www.youtube.com/watch?v=${widget.videoId}";
                controller.pause();
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Abrir en YouTube"),
                    content: const Text(
                      "¿Quieres abrir este trailer directamente en la app de YouTube o navegador?",
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("Abrir"),
                        onPressed: () async {
                          final url =
                              "https://www.youtube.com/watch?v=${widget.videoId}";
                          Navigator.pop(context);
                          await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text("Ver en YouTube"),
            ),

            const SizedBox(height: 20),

            // SECCIÓN SUGERENCIAS O CONTENIDO ADICIONAL
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "¿Qué sigue?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "• Mira las reseñas y comentarios.\n"
                      "• Agrega la película a tu lista de favoritos.\n"
                      "• Explora títulos similares.\n"
                      "• Comparte el trailer con tus amigos.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
