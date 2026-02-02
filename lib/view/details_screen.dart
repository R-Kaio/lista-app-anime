import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/anime_model.dart';
import '../viewmodels/library_viewmodel.dart';

class DetailsScreen extends StatefulWidget {
  final Anime anime;

  const DetailsScreen({super.key, required this.anime});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isSaved = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
  }

  void _checkInitialStatus() async {
    final viewModel = context.read<LibraryViewModel>();
    final saved = await viewModel.isAnimeSaved(widget.anime.id);

    if (mounted) {
      setState(() {
        isSaved = saved;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final libraryViewModel = context.read<LibraryViewModel>();

    return Scaffold(
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  isSaved = !isSaved;
                });

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSaved
                          ? 'Salvo na biblioteca!'
                          : 'Removido da biblioteca',
                    ),
                    duration: const Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // OPERAÇÃO NO BANCO (Segundo plano)
                await libraryViewModel.toggleSave(widget.anime);
              },
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? Colors.white : null,
              ),
              label: Text(
                isSaved ? 'Salvo' : 'Salvar',
                style: TextStyle(color: isSaved ? Colors.white : null),
              ),
              backgroundColor: isSaved
                  ? Colors.green
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
            ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,

            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.anime.title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [const Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.anime.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[800]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),

          // Conteúdo da Página
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Container(),
                    secondChild: Column(
                      children: [
                        _buildManagementCard(libraryViewModel),
                        const SizedBox(height: 24),
                      ],
                    ),
                    crossFadeState: isSaved
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),

                  // Informações Básicas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(
                        Icons.star,
                        '${widget.anime.score ?? "N/A"}',
                        Colors.amber,
                      ),
                      _buildInfoChip(
                        Icons.movie,
                        '${widget.anime.totalEpisodes ?? "?"} Eps',
                        Colors.blue,
                      ),
                      _buildInfoChip(Icons.tv, 'Anime', Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Sinopse",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.anime.synopsis ?? "Sem descrição.",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Pequeno para ícones (Nota, Eps)
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // PAINEL DE CONTROLE
  Widget _buildManagementCard(LibraryViewModel viewModel) {
    bool canIncrement =
        widget.anime.totalEpisodes == null ||
        widget.anime.watchedEpisodes < widget.anime.totalEpisodes!;

    return Card(
      elevation: 4,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.indigo[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Meu Progresso",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const Divider(),

            // Dropdown de Status
            DropdownButton<String>(
              value: widget.anime.status,
              isExpanded: true,
              underline: Container(),
              items: ['Planejo Ver', 'Assistindo', 'Completo', 'Dropado'].map((
                String status,
              ) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    widget.anime.status = newValue;
                  });
                  viewModel.updateAnime(widget.anime);
                }
              },
            ),

            const SizedBox(height: 10),

            // Contador de Episódios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Episódios assistidos:"),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: widget.anime.watchedEpisodes > 0
                          ? () {
                              setState(() {
                                widget.anime.watchedEpisodes--;
                                if (widget.anime.status == 'Completo') {
                                  widget.anime.status = 'Assistindo';
                                }
                              });
                              viewModel.updateAnime(widget.anime);
                            }
                          : null,
                    ),

                    Text(
                      '${widget.anime.watchedEpisodes} / ${widget.anime.totalEpisodes ?? "?"}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: canIncrement
                          ? () {
                              setState(() {
                                widget.anime.watchedEpisodes++;

                                // REGRA 1: Se atingiu o total, vira "Completo"
                                if (widget.anime.totalEpisodes != null &&
                                    widget.anime.watchedEpisodes ==
                                        widget.anime.totalEpisodes) {
                                  widget.anime.status = 'Completo';
                                }
                                // REGRA 2: Se começou a ver, vira "Assistindo"
                                else if (widget.anime.status == 'Planejo Ver') {
                                  widget.anime.status = 'Assistindo';
                                }
                              });
                              viewModel.updateAnime(widget.anime);
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),

            // Barra de Progresso
            if (widget.anime.totalEpisodes != null &&
                widget.anime.totalEpisodes! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: LinearProgressIndicator(
                  value:
                      (widget.anime.watchedEpisodes /
                              widget.anime.totalEpisodes!)
                          .clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  color:
                      widget.anime.watchedEpisodes == widget.anime.totalEpisodes
                      ? Colors.blue
                      : Colors.green,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
