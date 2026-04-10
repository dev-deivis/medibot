# CLAUDE.md — MediBot

## Descripción del proyecto
App Flutter para escanear recetas médicas y encontrar medicamentos genéricos equivalentes más económicos, con farmacias cercanas en LATAM (México, Colombia, Venezuela, Perú, Rep. Dominicana).

## Stack
- **Flutter/Dart** — Android físico (no emulador)
- **Firebase Auth** — email/password + Google Sign-In
- **Cloud Firestore** — base de datos principal
- **Firebase Storage** — imágenes de recetas
- **Firebase Messaging** — notificaciones push (instalado, sin implementar)
- **Riverpod** — state management
- **Google ML Kit** — OCR para recetas (instalado, sin implementar)
- **Google Maps Flutter** — mapa de farmacias (instalado, sin implementar)
- **Geolocator / Geocoding** — ubicación (instalado, sin implementar)
- **Image Picker** — cámara y galería (instalado, sin implementar)

## Comandos frecuentes
```bash
flutter run
flutter analyze
flutter pub get
```

## Arquitectura
Clean Architecture parcial:
- `lib/data/` — modelos y repositorios
- `lib/presentation/screens/` — pantallas
- `lib/providers/` — providers de Riverpod
- `lib/core/` — tema y utilidades
- `lib/domain/` — **VACÍO**, sin use cases

## Tema visual
- Color primario: verde médico `#1A6B3C`
- Material 3
- Fuente del tema en `lib/core/app_theme.dart`

---

## Estado actual de implementación

### ✅ Implementado y funcional

| Módulo | Archivos clave |
|--------|---------------|
| Auth completa (email + Google, sign out, reset password en repo) | `lib/data/repositories/auth_repository.dart`, `lib/providers/auth_provider.dart` |
| Búsqueda de medicamentos en Firestore (case-insensitive, límite 20) | `lib/data/repositories/medication_repository.dart` |
| Historial: guardar, listar, eliminar item, limpiar todo | `lib/data/repositories/search_history_repository.dart`, `lib/providers/search_history_provider.dart` |
| Onboarding con selector de país | `lib/presentation/screens/splash/onboarding_screen.dart` |
| Auth screen (login + registro + Google) | `lib/presentation/screens/auth/auth_screen.dart` |
| Home screen con navegación | `lib/presentation/screens/home/home_screen.dart` |
| Search screen con resultados en tiempo real | `lib/presentation/screens/search/search_screen.dart` |
| History screen completa | `lib/presentation/screens/history/history_screen.dart` |
| Splash screen corregida | `lib/presentation/screens/splash/splash_screen.dart` |
| Routing en main.dart con authStateProvider | `lib/main.dart` |

### ⚠️ Parcialmente implementado

| Problema | Ubicación | Qué falta |
|----------|-----------|-----------|
| Botón "¿Olvidé mi contraseña?" sin acción | `auth_screen.dart:205` — `onPressed: () {}` | Conectar a `authRepository.resetPassword()` que ya existe |
| Al tocar medicamento en búsqueda no navega | `search_screen.dart:221` — TODO comentado | Crear `MedicationDetailScreen` y conectar |
| Al tocar item en historial no navega al detalle | `history_screen.dart` | Mismo que arriba |
| Botón "Escáner" muestra SnackBar "próximamente" | `home_screen.dart:71-73` | Crear `ScannerScreen` |

### ❌ No implementado

| Pantalla / Módulo | RF del SRS | Notas |
|-------------------|-----------|-------|
| `MedicationDetailScreen` | RF-13, RF-16, RF-26 | Pantalla de detalle con principio activo, dosis, precios comparados |
| `ScannerScreen` + pipeline OCR | RF-06 a RF-10 | ML Kit ya instalado |
| `PharmacyMapScreen` | RF-17 a RF-21 | Google Maps, geolocator ya instalados |
| `ProfileScreen` | RF-27 a RF-30 | Ver/editar perfil, cambiar país, notificaciones, eliminar cuenta |
| Modo invitado (anonymous auth) | RF-05 | Sin `signInAnonymously()` ni botón en AuthScreen |
| Filtro por país en búsquedas | RF-15 | Query no filtra por `paisId` |
| `PharmacyRepository` | — | Modelo `Pharmacy` existe, repositorio no |
| Push notifications | — | `firebase_messaging` instalado, sin servicio |
| Tests funcionales | — | `widget_test.dart` roto (referencia a `MyApp` inexistente) |

---

## Schema de Firestore

### Colecciones actualmente usadas en código
- `medications` — campo `nameLower` para búsqueda case-insensitive
- `searchHistory` — campos: userId, query, searchedAt, medicationId

### Colecciones requeridas por el SRS (faltan)
- `usuarios` — uid, nombre, email, pais_id, foto_url, notificaciones
- `paises` — pais_id (MX/CO/VE/PE/DO), nombre, moneda, simbolo_moneda
- `principios_activos` — nombre DCI según OMS, categoria, requiere_receta
- `precios_por_pais` — medicamento_id, pais_id, precio, presentacion, disponible
- `farmacias` — nombre, pais_id, latitud, longitud, telefono, horario
- `inventario_farmacias` — farmacia_id, medicamento_id, precio_local, stock_disponible

---

## Slash commands disponibles

Están en `.claude/commands/` (solo locales, no en GitHub):

| Comando | Qué hace |
|---------|----------|
| `/status` | Tabla de cobertura SRS vs código actual |
| `/fix-password-reset` | Conecta botón "¿Olvidé mi contraseña?" |
| `/implement-details` | Crea MedicationDetailScreen |
| `/implement-profile` | Crea ProfileScreen completa |
| `/implement-scanner` | Implementa OCR con ML Kit |
| `/implement-pharmacy` | Implementa mapa de farmacias |
| `/update-db-schema` | Alinea Firestore al SRS |
| `/fix-tests` | Arregla tests rotos y crea cobertura básica |
| `/guest-mode` | Implementa modo invitado con anonymous auth |

## Orden de implementación sugerido
1. `/fix-password-reset` — rápido, RF-03
2. `/implement-details` — desbloquea flujo búsqueda → detalle
3. `/update-db-schema` — base para precios y farmacias
4. `/implement-profile` — RF-27 a RF-30
5. `/implement-scanner` — RF-06 a RF-10
6. `/implement-pharmacy` — RF-17 a RF-21
7. `/guest-mode` — RF-05
8. `/fix-tests` — al final

## Configuración Firebase
- Project ID: `medibot-f2fff`
- `google-services.json` está en `.gitignore` — NO se sube al repo
- Cada desarrollador necesita su propio `google-services.json`

## Notas importantes
- Target: Android físico, no emulador
- `flutter analyze` después de cada cambio importante
- El `domain/` layer está vacío — no crear use cases a menos que se pida explícitamente
- Los precios en el modelo `Medication` actual no coinciden con el SRS — el SRS los maneja en colección separada `precios_por_pais`
