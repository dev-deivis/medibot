# Fix: Splash Screen

Problema real en el código: `lib/presentation/screens/splash/splash_screen.dart` navega a un `Scaffold` genérico con texto "Home Placeholder" en vez de la pantalla real.

Corrige la splash screen para que:

1. Al terminar el delay de 2 segundos, verifique el estado de autenticación usando `authStateProvider` (ya existe en `lib/providers/auth_provider.dart`)
2. Si hay usuario autenticado → navegar a `HomeScreen`
3. Si no hay usuario → navegar a `OnboardingScreen` (si es primer inicio) o `AuthScreen`
4. El "primer inicio" puede detectarse con `SharedPreferences` o simplemente navegar siempre a `AuthScreen` si no hay sesión

Contexto del código:
- Provider de auth: `lib/providers/auth_provider.dart` → `authStateProvider`
- Home screen: `lib/presentation/screens/home/home_screen.dart`
- Auth screen: `lib/presentation/screens/auth/auth_screen.dart`
- Onboarding: `lib/presentation/screens/splash/onboarding_screen.dart`

Lee el archivo actual antes de modificar. No cambies el diseño visual de la splash, solo la lógica de navegación.
