# Implementar: Pantalla de Perfil / Configuración (RF-27 a RF-30)

Pantalla que NO EXISTE en el código. El bottom navigation bar en `home_screen.dart` tiene un ícono de perfil sin acción.

## Qué crear

### 1. Pantalla: `lib/presentation/screens/profile/profile_screen.dart`

Secciones a implementar:

**Sección de usuario (RF-27):**
- Avatar circular con foto de Google o inicial del nombre
- Nombre completo
- Email
- País seleccionado (con banderita emoji)

**Sección de configuración:**
- Selector de país (RF-28): dropdown con los 5 países del SRS (México 🇲🇽, Colombia 🇨🇴, Venezuela 🇻🇪, Perú 🇵🇪, Rep. Dominicana 🇩🇴)
  - Al cambiar, guardar en Firestore colección `usuarios` campo `pais_id`
- Toggle de notificaciones (RF-29): Switch widget, guardar preferencia
- Botón "Cerrar sesión" (RF-04): usar `authRepository.signOut()`, redirigir a AuthScreen

**Sección peligrosa:**
- Botón "Eliminar cuenta" (RF-30): con AlertDialog de confirmación doble, llamar a Firebase Auth `user.delete()`

### 2. Conectar en HomeScreen

En `lib/presentation/screens/home/home_screen.dart`, el bottom nav tiene 5 items. Conectar el item de perfil (índice 4) para navegar a `ProfileScreen`.

## Providers a crear/extender

Crear `lib/providers/user_provider.dart`:
- Provider para leer/escribir datos de usuario en Firestore colección `usuarios`
- Provider para el país seleccionado actualmente

## Auth repository
- `signOut()` ya existe en `lib/data/repositories/auth_repository.dart`
- Para `deleteAccount()` agregar método nuevo

Requisitos SRS cubiertos: RF-04, RF-27, RF-28, RF-29, RF-30
