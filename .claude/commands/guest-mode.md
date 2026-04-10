# Implementar: Modo Invitado (RF-05)

El SRS requiere que usuarios sin cuenta puedan usar búsqueda manual con funcionalidad limitada (sin historial).

## Estado actual
- `auth_screen.dart` NO tiene botón de "Continuar sin cuenta"
- Toda la app asume usuario autenticado

## Qué implementar

### 1. Agregar botón en AuthScreen

En `lib/presentation/screens/auth/auth_screen.dart`, agregar debajo de los botones de login/registro:
```
─── o ───
[Continuar sin cuenta →]
```
Al presionar, navegar directamente a `HomeScreen`.

### 2. Crear login anónimo en AuthRepository

En `lib/data/repositories/auth_repository.dart`, agregar:
```dart
Future<UserCredential> signInAnonymously() async {
  return await _firebaseAuth.signInAnonymously();
}
```
Firebase Auth tiene soporte nativo para sesiones anónimas. Esto permite tracking básico sin datos personales.

### 3. Limitar funciones según tipo de usuario

En providers que requieren `userId` (como `searchHistoryNotifierProvider`), verificar:
```dart
// Si el usuario es anónimo, no guardar historial
final user = ref.watch(authStateProvider).value;
if (user == null || user.isAnonymous) return; // skip
```

### 4. Mostrar banner en HomeScreen

Si el usuario es invitado, mostrar un banner suave arriba del Home:
```
[Inicia sesión para guardar tu historial →]
```

### 5. Actualizar SplashScreen

Después del fix de splash, si el usuario tiene sesión anónima también navegar a Home (ya son "usuario invitado").

Requisito SRS: RF-05 — "El sistema debe permitir usar búsqueda manual sin registrarse, con funcionalidad limitada."
