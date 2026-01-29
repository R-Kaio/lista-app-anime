import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_app/models/anime_model.dart';
// Certifique-se que o import está puxando o arquivo correto
import 'package:anime_app/viewmodels/library_viewmodel.dart';

class DetailsScreen extends StatelessWidget {
  final Anime anime;

  // Receber o objeto anime
  const DetailsScreen({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    // CORREÇÃO 1: Nome da variável em minúsculo (camelCase)
    // E nome da Classe com M maiúsculo (LibraryViewModel)
    final libraryViewModel = Provider.of<LibraryViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      // Botão Flutuante para salvar
      floatingActionButton: FutureBuilder<bool>(
        // CORREÇÃO 2: Usando a variável (minúsculo) e não a classe
        future: libraryViewModel.isAnimeSaved(anime.id),
        builder: (context, snapshot) {
          final isSaved = snapshot.data ?? false;

          return FloatingActionButton.extended(
            onPressed: () async {
              // CORREÇÃO 3: Usando a variável
              await libraryViewModel.toggleSave(anime);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isSaved ? 'Removido da biblioteca' : 'Salvo na biblioteca!',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
              // Atualiza o visual do botão
              (context as Element).markNeedsBuild();
            },
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            label: Text(isSaved ? 'Salvo' : 'Salvar'),
            backgroundColor: isSaved
                ? Colors.green
                : Theme.of(context).primaryColor,
          );
        },
      ),
      appBar: AppBar(title: Text(anime.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titulo e Nota
            SizedBox(
              height: 300,
              child: CachedNetworkImage(
                imageUrl: anime.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          anime.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text(
                            ' ${anime.score ?? "N/A"}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sinopse",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Texto da Sinopse
                  Text(
                    anime.synopsis ?? "Sem descrição disponível.",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
