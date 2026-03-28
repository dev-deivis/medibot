import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/app_theme.dart';
import 'presentation/screens/splash/onboarding_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/search/search_screen.dart';
import 'presentation/screens/history/history_screen.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es', null);

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(
    const ProviderScope(
      child: MediBotApp(),
    ),
  );
}

class MediBotApp extends ConsumerWidget {
  const MediBotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'MediBot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: {
        '/home': (_) => const HomeScreen(),
        '/search': (_) => const SearchScreen(),
        '/history': (_) => const HistoryScreen(),
      },
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          }
          return const OnboardingScreen();
        },
        loading: () => const SplashScreen(),
        error: (e, trace) => Scaffold(
          body: Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
