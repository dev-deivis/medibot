# Implementar: Pantalla de Detalle del Medicamento (RF-13, RF-16, RF-26)

Falta implementada en el código:
- `lib/presentation/screens/search/search_screen.dart` línea ~221 tiene un TODO: "Navigate to results/details screen"
- `lib/presentation/screens/history/history_screen.dart` — al tocar un item del historial tampoco navega a detalle (RF-26)

## Qué crear

### 1. Pantalla: `lib/presentation/screens/medication/medication_detail_screen.dart`

Recibe un objeto `Medication` como parámetro de navegación y muestra:
- Nombre comercial (grande, con color primario #1A6B3C)
- Principio activo / nombre genérico
- Dosis y forma farmacéutica (tableta, jarabe, etc.)
- Descripción
- Aviso legal: "Esta información no reemplaza la consulta médica" (requerimiento RD-05)
- Botón flotante: "Ver farmacias cercanas" → navega a mapa (stub por ahora si el mapa no está listo)

### 2. Actualizar navegación en search_screen.dart

En el TODO de línea ~221, reemplazar el comentario por:
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => MedicationDetailScreen(medication: medication),
));
```

### 3. Actualizar navegación en history_screen.dart

Al tocar un item del historial, navegar a `MedicationDetailScreen`. Nota: el historial guarda `medicationId` opcionalmenteen `SearchHistoryItem`. Si existe, cargarlo desde Firestore usando `MedicationRepository.getById()`.

## Modelos existentes a usar
- `lib/data/models/medication.dart` — modelo Medication ya completo
- `lib/data/repositories/medication_repository.dart` — método `getById()` ya existe
- `lib/providers/medication_provider.dart` — extender con provider para detalle

Requisitos SRS cubiertos: RF-13, RF-16 (comparación precio marca vs genérico si hay datos), RF-26
