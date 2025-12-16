import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/anime_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // false é importante aqui porque não quero redesenhar a tela dentro do initState.
      Provider.of<AnimeViewmodel>(context, listen: false).fetchAnimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Animes'), centerTitle: true),

      // O Consumer observa o AnimeViewModel. Qualquer notifyListeners() lá, refaz essa parte.
      body: Consumer<AnimeViewmodel>(
        builder: (context, viewModel, child) {
          // Estado carregamento
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado erro
          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Text(
                viewModel.error,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          // Estado Sucesso
          return ListView.builder(
            itemCount: viewModel.animes.length,
            itemBuilder: (context, index) {
              final anime = viewModel.animes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    anime.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Score: ${anime.score ?? "N/A"}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    print('Clicou no anime: ${anime.title}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
