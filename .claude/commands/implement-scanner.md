# Implementar: Escáner de Receta con OCR (RF-06 a RF-10)

Módulo más complejo. Las dependencias YA están instaladas en `pubspec.yaml`:
- `google_mlkit_text_recognition: ^0.14.0`
- `image_picker: ^1.1.2`
- `firebase_storage: ^12.4.1`

El botón "Escanear Receta" en `home_screen.dart` línea ~71 muestra solo un SnackBar "próximamente".

## Qué crear

### 1. Pantalla: `lib/presentation/screens/scanner/scanner_screen.dart`

**Vista de cámara / selección:**
- Dos botones: "Tomar foto" y "Elegir de galería"
- Usar `ImagePicker` para ambas opciones
- Solicitar permisos de cámara y galería con manejo de rechazo (RF-06)
- Mostrar preview de la imagen seleccionada
- Botón "Analizar receta"

**Procesamiento OCR (RF-07, RF-08):**
- Al presionar "Analizar", usar `TextRecognizer` de ML Kit
- Procesar la imagen con `InputImage.fromFile()`
- Extraer bloques de texto reconocido
- Identificar el nombre del medicamento: buscar patrones comunes en recetas (palabras en mayúsculas, seguidas de dosis como "500mg", "mg/ml")
- Mostrar loading mientras procesa

**Manejo de error (RF-10):**
- Si el texto extraído no contiene ningún medicamento identificable → mostrar diálogo: "No pudimos leer la receta. ¿Deseas buscar manualmente?" con botón que navega a SearchScreen

**Al identificar medicamento:**
- Navegar a `MedicationDetailScreen` o `SearchScreen` con el nombre pre-llenado

### 2. Provider: `lib/providers/scanner_provider.dart`

```dart
// Estados: idle, loading, success(String medicamento), error(String msg)
final scannerProvider = StateNotifierProvider<ScannerNotifier, ScannerState>
```

### 3. Conectar en HomeScreen

Reemplazar el SnackBar en `home_screen.dart` por:
```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => ScannerScreen()));
```

### 4. Opcionalmente: subir imagen a Firebase Storage (RF-09)
Si el usuario quiere guardar la receta, subirla a `storage/recetas/{uid}/{timestamp}.jpg`

## Notas importantes
- ML Kit funciona on-device, no necesita internet para OCR
- Solicitar permisos en Android: agregar en `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.CAMERA"/>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
  ```

Requisitos SRS cubiertos: RF-06, RF-07, RF-08, RF-09, RF-10
