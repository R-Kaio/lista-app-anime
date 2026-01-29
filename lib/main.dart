import 'package:anime_app/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'repositories/anime_repository.dart';
import 'services/api_service.dart';
import 'viewmodels/anime_viewmodel.dart';
import 'viewmodels/library_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider da Home (API)
        ChangeNotifierProvider(
          create: (context) => AnimeViewModel(
            repository: AnimeRepository(apiService: ApiService()),
          ),
        ),

        // Provider da Biblioteca (Banco de Dados)
        ChangeNotifierProvider(
          create: (context) => LibraryViewModel()..loadLibrary(),
        ),
      ],
      child: MaterialApp(
        title: 'Anime Manager',
        debugShowCheckedModeBanner: false,

        // TEMA CLARO
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),

        // TEMA ESCURO
        darkTheme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
        ),

        themeMode: ThemeMode.system,

        home: const MainScreen(),
      ),
    );
  }
}
