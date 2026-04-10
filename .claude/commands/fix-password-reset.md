# Fix: Recuperación de contraseña (RF-03)

Problema real: en `lib/presentation/screens/auth/auth_screen.dart` el botón "¿Olvidaste tu contraseña?" no tiene acción implementada.

El método `resetPassword` YA EXISTE en `lib/data/repositories/auth_repository.dart`. Solo falta conectarlo a la UI.

Implementa:
1. Lee `auth_screen.dart` y `auth_repository.dart` primero
2. Conecta el botón "¿Olvidaste tu contraseña?" para que:
   - Muestre un `AlertDialog` pidiendo el email
   - El campo de email puede pre-llenarse si el usuario ya escribió su email
   - Al confirmar, llame a `authRepository.resetPassword(email)`
   - Muestre Snackbar de éxito: "Revisa tu correo para restablecer tu contraseña"
   - Maneje el error si el email no existe
3. No crees nuevas pantallas, todo dentro del AlertDialog existente en auth_screen.dart

Requisito SRS: RF-03 — "El sistema debe enviar un correo de recuperación de contraseña al email registrado."
