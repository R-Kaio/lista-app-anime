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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnimeViewModel>().fetchAnimes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AnimeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.isSearching ? 'Resultados' : 'Top Animes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // BARRA DE PESQUISA
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar anime (ex: Naruto)...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    viewModel.isSearching || _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<AnimeViewModel>().fetchAnimes(
                            forceRefresh: true,
                          );
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<AnimeViewModel>().search(value);
                }
              },
            ),
          ),

          // LISTA DE RESULTADOS
          Expanded(
            child: Builder(
              builder: (context) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.error.isNotEmpty) {
                  return Center(child: Text(viewModel.error));
                }

                if (viewModel.animes.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum anime encontrado.',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    if (viewModel.isSearching) {
                      await viewModel.search(_searchController.text);
                    } else {
                      await viewModel.fetchAnimes(forceRefresh: true);
                    }
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: viewModel.animes.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final anime = viewModel.animes[index];

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                Text(
                                  ' ${anime.score ?? "N/A"}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.movie,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                Text(
                                  ' ${anime.totalEpisodes ?? "?"} eps',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(anime: anime),
                            ),
                          ).then((_) {});
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
