# Implementar: Mapa de Farmacias (RF-17 a RF-21)

Módulo sin implementar. Dependencias YA instaladas:
- `google_maps_flutter: ^2.10.0`
- `geolocator: ^13.0.2`
- `geocoding: ^3.0.0`

El modelo `Pharmacy` ya existe en `lib/data/models/pharmacy.dart` con latitud, longitud, nombre, dirección, teléfono, horario, y lista de precios.

## Qué crear

### 1. Repository: `lib/data/repositories/pharmacy_repository.dart`

```dart
class PharmacyRepository {
  // Obtener farmacias cercanas con un medicamento dado
  // Parámetros: medicamentoId, latitud, longitud, radioKm (default 5km)
  // Query Firestore: colección 'farmacias' + subcolección o join con 'inventario_farmacias'
  Future<List<Pharmacy>> getNearbyPharmacies(String medicamentoId, double lat, double lng);

  // Obtener detalle de una farmacia
  Future<Pharmacy?> getById(String farmaciaId);
}
```

### 2. Provider: `lib/providers/pharmacy_provider.dart`

```dart
// Provider de ubicación del usuario
final userLocationProvider = FutureProvider<Position>(...);

// Provider de farmacias cercanas para un medicamento
final nearbyPharmaciesProvider = FutureProvider.family<List<Pharmacy>, String>(...);
```

### 3. Pantalla: `lib/presentation/screens/pharmacy/pharmacy_map_screen.dart`

Recibe `medicamentoId` como parámetro.

**Implementar:**
- Solicitar permiso de ubicación al iniciar (RF-20), manejar rechazo con mensaje explicativo
- Mostrar `GoogleMap` con la posición actual del usuario
- Marcadores azules para cada farmacia cercana
- Al tocar un marcador: mostrar `BottomSheet` con:
  - Nombre de la farmacia
  - Dirección
  - Horario
  - Precio del medicamento en esa farmacia
  - Botón "Cómo llegar" (RF-21)

**Botón "Cómo llegar" (RF-21):**
```dart
// Abrir Google Maps o Waze con la ruta
final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
launchUrl(Uri.parse(url));
// Agregar dependencia: url_launcher: ^6.2.0
```

**Lista alternativa:**
- FAB o tab para ver lista de farmacias en lugar del mapa
- Cada item muestra distancia, precio y disponibilidad

### 4. Permisos Android

En `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

Y en `android/app/build.gradle.kts` verificar que el API key de Google Maps esté configurado.

### 5. Conectar desde MedicationDetailScreen

El botón "Ver farmacias cercanas" en la pantalla de detalle debe navegar a `PharmacyMapScreen(medicamentoId: medication.id)`.

## Nota sobre datos de prueba
La colección `farmacias` e `inventario_farmacias` en Firestore deben tener datos. Si no hay, mostrar mensaje: "No encontramos farmacias cercanas con este medicamento disponible."

Requisitos SRS cubiertos: RF-17, RF-18, RF-19, RF-20, RF-21
