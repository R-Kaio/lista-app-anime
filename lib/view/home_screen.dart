import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/anime_viewmodel.dart';
import 'details_screen.dart';

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
      context.read<AnimeViewModel>().fetchAnimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Animes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<AnimeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          //  Erro
          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    'Ops! Algo deu errado.',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      viewModel.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => viewModel.fetchAnimes(forceRefresh: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          // Sucesso
          return RefreshIndicator(
            onRefresh: () async {
              await viewModel.fetchAnimes(forceRefresh: true);
            },
            child: ListView.separated(
              itemCount: viewModel.animes.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final anime = viewModel.animes[index];

                return ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      width: 50,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  title: Text(
                    anime.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(
                        ' ${anime.score ?? "N/A"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text('${anime.totalEpisodes ?? "?"} eps'),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(anime: anime),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
