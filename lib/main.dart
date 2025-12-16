import 'package:anime_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repositories/anime_repository.dart';
import 'services/api_service.dart';
import 'viewmodels/anime_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Injeção de Dependências
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AnimeViewmodel(
            repository: AnimeRepository(apiService: ApiService()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Anime App',
        debugShowCheckedModeBanner: false,

        // Tema Claro (padrão)
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),

        // Tema Escuro
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
