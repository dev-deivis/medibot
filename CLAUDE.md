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
python3 scripts/seed_firestore.py   # poblar Firestore con medicamentos de prueba
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
| Auth completa (email + Google, sign out) | `lib/data/repositories/auth_repository.dart`, `lib/providers/auth_provider.dart` |
| Recuperación de contraseña (RF-03) | `lib/presentation/screens/auth/auth_screen.dart` — AlertDialog conectado a `resetPassword()` |
| Splash screen con routing por authState | `lib/presentation/screens/splash/splash_screen.dart`, `lib/main.dart` |
| Búsqueda de medicamentos en Firestore (case-insensitive, límite 20) | `lib/data/repositories/medication_repository.dart` |
| Historial: guardar, listar, eliminar item, limpiar todo | `lib/data/repositories/search_history_repository.dart`, `lib/providers/search_history_provider.dart` |
| Detalle del medicamento (RF-13, RF-26) | `lib/presentation/screens/medication/medication_detail_screen.dart` |
| Navegación búsqueda → detalle | `lib/presentation/screens/search/search_screen.dart` |
| Navegación historial → detalle (con carga por medicationId) | `lib/presentation/screens/history/history_screen.dart` |
| Onboarding con selector de país | `lib/presentation/screens/splash/onboarding_screen.dart` |
| Auth screen (login + registro + Google) | `lib/presentation/screens/auth/auth_screen.dart` |
| Home screen con navegación | `lib/presentation/screens/home/home_screen.dart` |
| History screen completa | `lib/presentation/screens/history/history_screen.dart` |

### ⚠️ Parcialmente implementado

| Problema | Ubicación | Qué falta |
|----------|-----------|-----------|
| Botón "Escáner" muestra SnackBar "próximamente" | `home_screen.dart:71-73` | Crear `ScannerScreen` con ML Kit |
| FAB "Ver farmacias cercanas" en detalle | `medication_detail_screen.dart` | Conectar a `PharmacyMapScreen` cuando exista |

### ❌ No implementado

| Pantalla / Módulo | RF del SRS | Notas |
|-------------------|-----------|-------|
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

### Colecciones activas con datos
- `medications` — **26 documentos** con medicamentos comunes de LATAM (genéricos + marcas). Campo `nameLower` para búsqueda case-insensitive. Seed en `scripts/seed_firestore.py`
- `searchHistory` — campos: userId, query, searchedAt, medicationId

### Reglas de seguridad Firestore (configuradas)
- `medications`: lectura pública, escritura solo autenticados
- `searchHistory`: lectura/escritura solo al propio usuario (`request.auth.uid == resource.data.userId`)

### Colecciones requeridas por el SRS (faltan)
- `usuarios` — uid, nombre, email, pais_id, foto_url, notificaciones
- `paises` — pais_id (MX/CO/VE/PE/DO), nombre, moneda, simbolo_moneda
- `principios_activos` — nombre DCI según OMS, categoria, requiere_receta
- `precios_por_pais` — medicamento_id, pais_id, precio, presentacion, disponible
- `farmacias` — nombre, pais_id, latitud, longitud, telefono, horario
- `inventario_farmacias` — farmacia_id, medicamento_id, precio_local, stock_disponible

---

## Scripts

### `scripts/seed_firestore.py`
Puebla la colección `medications` con 26 medicamentos comunes de LATAM.
Requiere `scripts/serviceAccountKey.json` (descargado de Firebase Console → Cuentas de servicio).
`serviceAccountKey.json` está en `.gitignore` — nunca se sube al repo.

```bash
pip install firebase-admin --break-system-packages
python3 scripts/seed_firestore.py
```

---

## Slash commands disponibles

Están en `.claude/commands/` (incluidos en el repo):

| Comando | Qué hace |
|---------|----------|
| `/status` | Tabla de cobertura SRS vs código actual |
| `/fix-password-reset` | ✅ Ya ejecutado |
| `/implement-details` | ✅ Ya ejecutado |
| `/implement-profile` | Crea ProfileScreen completa |
| `/implement-scanner` | Implementa OCR con ML Kit |
| `/implement-pharmacy` | Implementa mapa de farmacias |
| `/update-db-schema` | Alinea Firestore al SRS |
| `/fix-tests` | Arregla tests rotos y crea cobertura básica |
| `/guest-mode` | Implementa modo invitado con anonymous auth |

## Orden de implementación restante
1. `/implement-profile` — RF-27 a RF-30
2. `/implement-scanner` — RF-06 a RF-10
3. `/implement-pharmacy` — RF-17 a RF-21
4. `/guest-mode` — RF-05
5. `/fix-tests` — al final

## Configuración Firebase
- Project ID: `medibot-f2fff`
- `google-services.json` está en `.gitignore` — NO se sube al repo
- `scripts/serviceAccountKey.json` está en `.gitignore` — NO se sube al repo
- Cada desarrollador necesita su propio `google-services.json`

## Notas importantes
- Target: Android físico, no emulador
- `flutter analyze` después de cada cambio importante
- El `domain/` layer está vacío — no crear use cases a menos que se pida explícitamente
- Los precios en el modelo `Medication` actual no coinciden con el SRS — el SRS los maneja en colección separada `precios_por_pais`
- Los warnings de `withOpacity` en varios archivos son pre-existentes, no bloquean compilación
