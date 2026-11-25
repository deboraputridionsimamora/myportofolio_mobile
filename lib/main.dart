import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ApiClient dibuat sekali dan dibagi ke semua layar lewat Provider
    return Provider<ApiClient>(
      create: (_) => ApiClient(),
      dispose: (_, client) => client.close(),
      child: MaterialApp(
        title: 'MyPortfolio',
        theme: ThemeData(
          // warna dasar indigo, warna secondary diganti amber biar kartu tombolnya beda
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            secondary: Colors.amber[700],
          ),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
