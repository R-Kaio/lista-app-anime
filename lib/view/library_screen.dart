import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/library_viewmodel.dart';
import 'details_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Coleção', style: GoogleFonts.poppins()),
      ),

      body: Consumer<LibraryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Lista Vazia
          if (viewModel.library.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sua coleção está vazia',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Lista com Animes (Grade)
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: viewModel.library.length,
            itemBuilder: (context, index) {
              final anime = viewModel.library[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailsScreen(anime: anime),
                    ),
                  ).then((_) {
                    viewModel.loadLibrary();
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        anime.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: anime.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[800]),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
