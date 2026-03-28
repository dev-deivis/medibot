# Actualizar: Esquema de Base de Datos Firestore

El SRS v1.0 define 8 colecciones. El código actual solo usa 2 (`medications`, `searchHistory`). Las demás deben crearse/alinearse.

## Colecciones requeridas por el SRS vs estado actual

| Colección SRS | Nombre actual en código | Estado |
|--------------|------------------------|--------|
| `usuarios` | No existe (solo Firebase Auth) | ❌ Crear |
| `paises` | No existe | ❌ Crear |
| `principios_activos` | No existe | ❌ Crear |
| `medicamentos` | `medications` (diferente nombre y estructura) | ⚠️ Adaptar |
| `precios_por_pais` | Incluido en `medications` como array | ⚠️ Separar |
| `farmacias` | No existe como colección | ❌ Crear |
| `inventario_farmacias` | Parcial en modelo `Pharmacy` | ⚠️ Crear colección |
| `historial_usuarios` | `searchHistory` (estructura diferente) | ⚠️ Adaptar |

## Qué hacer

### 1. Leer todos los modelos y repositorios actuales primero:
- `lib/data/models/medication.dart`
- `lib/data/models/pharmacy.dart`
- `lib/data/models/search_history.dart`
- `lib/data/repositories/medication_repository.dart`
- `lib/data/repositories/search_history_repository.dart`

### 2. Crear script de seed data

Crear `scripts/seed_firestore.dart` (ejecutable con `dart run`) que popule Firestore con datos de prueba:
- 5 países (MX, CO, VE, PE, DO)
- 10 principios activos comunes (amoxicilina, ibuprofeno, paracetamol, etc.)
- 20 medicamentos (marca + genéricos)
- Precios por país para cada medicamento
- 3 farmacias por país con inventario

### 3. Actualizar modelos para alinearse al SRS

El modelo `Medication` debe agregar:
- `principioActivoId` (FK a `principios_activos`)
- `esGenerico` (bool)
- `laboratorio` (String?)
- `nombresAlternativos` (List<String>)

El modelo `SearchHistoryItem` debe agregar:
- `metodoBusqueda` ('escaneo' | 'manual')
- `paisId` (String)

### 4. Actualizar repositorios

`MedicationRepository.search()` debe:
- Filtrar por `paisId` del usuario (RF-15)
- Separar búsqueda de marca vs genérico

### 5. Documentar en comentarios

No crear archivos de documentación extra. Agregar comentarios en los modelos indicando la colección Firestore correspondiente.

## Nota
No migres datos existentes en producción sin confirmación del usuario. Crear las nuevas colecciones en paralelo y migrar gradualmente.
