# Fix: Tests rotos y crear cobertura básica

El único test existente (`test/widget_test.dart`) está completamente roto:
- Referencia a `MyApp` que no existe (la clase se llama `MediBotApp` en `lib/main.dart`)
- Prueba un contador que no existe en la app

## Qué hacer

### 1. Lee primero
- `test/widget_test.dart`
- `lib/main.dart`
- `lib/data/repositories/auth_repository.dart`
- `lib/data/repositories/search_history_repository.dart`
- `lib/providers/auth_provider.dart`

### 2. Corregir `test/widget_test.dart`
Reemplazar el test genérico por un smoke test real:
```dart
testWidgets('App arranca sin errores', (tester) async {
  await tester.pumpWidget(ProviderScope(child: MediBotApp()));
  expect(find.byType(MaterialApp), findsOneWidget);
});
```

### 3. Crear `test/providers/auth_provider_test.dart`
Tests unitarios del provider de autenticación usando mocks de Firebase Auth.

### 4. Crear `test/repositories/search_history_repository_test.dart`
Tests unitarios del repositorio de historial con Firestore mockeado:
- Guardar búsqueda
- Obtener historial (ordenado por fecha)
- Eliminar item
- Limpiar todo

### 5. Crear `test/widgets/auth_screen_test.dart`
Tests de la pantalla de autenticación:
- Renderiza correctamente
- Validación de campos vacíos
- TabBar funciona entre Login y Registro

## Comandos para correr
```bash
flutter test
flutter test --coverage
flutter analyze
```

No uses `flutter_test` con Firebase real. Usa `fake_cloud_firestore` y `firebase_auth_mocks` como dev dependencies.

Agregar a `pubspec.yaml` dev_dependencies:
```yaml
fake_cloud_firestore: ^3.0.3
firebase_auth_mocks: ^0.14.1
mockito: ^5.4.4
build_runner: ^2.4.14  # ya existe
```
