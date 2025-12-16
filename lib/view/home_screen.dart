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
              child: Padding(
                padding: const EdgeInsetsGeometry.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ops! Algo deu errado.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        viewModel.fetchAnimes();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Estado de Sucesso (Lista com Pull-To-Refresh)
          return RefreshIndicator(
            onRefresh: () async {
              await viewModel.fetchAnimes();
            },
            color: Colors.blue,
            child: ListView.builder(
              physics:
                  const AlwaysScrollableScrollPhysics(), // garantir que funcione mesmo se tiver poucos itens
              itemCount: viewModel.animes.length,
              itemBuilder: (context, index) {
                final anime = viewModel.animes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
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
                    trailing: const Icon(Icons.arrow_forward_ios, size: 17),
                    onTap: () {
                      print('Clicou no anime: ${anime.title}');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
