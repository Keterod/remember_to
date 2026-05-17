# Modelo de datos inicial

Este modelo está pensado para una primera versión local con SQLite y Drift, dejando preparada la evolución hacia sincronización futura.

## Enfoque recomendado

Conviene usar una entidad general `Actividad` con un campo `tipo`, en lugar de crear tablas completamente separadas para tareas, recordatorios, eventos, rutinas y tareas mensuales desde el inicio.

### Razones

- Todas las actividades comparten campos: título, descripción, estado base, categoría futura, urgencia, fechas de creación y actualización.
- Las vistas Hoy, Próximas, Vencidas, Calendario y Agenda necesitan consultar varios tipos a la vez.
- El historial, enlaces, notificaciones, ocurrencias y categorías pueden relacionarse con una sola tabla principal.
- Drift facilita consultas tipadas e índices sobre una tabla principal.
- Se evita duplicar lógica de edición, eliminación, búsqueda y sincronización.

### Cuidado necesario

No todos los campos aplican a todos los tipos. Para evitar una tabla difícil de mantener, se recomienda:

- Mantener en `Actividad` los campos comunes y los campos de programación más usados.
- Usar `tipo` para validar reglas por tipo desde la capa de dominio.
- Usar tablas relacionadas para repetición, ocurrencias, notificaciones, enlaces, historial y aprendizaje.
- Considerar tablas detalle en el futuro si algún tipo crece mucho.

## Decisión sobre estados

El estado persistente principal de una actividad no debe mezclar estado real con condiciones calculadas.

Estados base principales del MVP para `Actividad`:

- `pendiente`
- `completada`

El estado `cancelada` queda como opción futura si se implementa una acción explícita de cancelación. No debe considerarse parte obligatoria del MVP.

No usar como estado persistente principal:

- `vencida`
- `reprogramada`

La condición **vencida** debe calcularse según fecha/hora y estado pendiente. Por ejemplo, una tarea pendiente con fecha límite pasada puede mostrarse como vencida, pero la base conserva su estado como `pendiente`.

La acción **reprogramada** debe registrarse en `HistorialActividad`, no guardarse como estado permanente.

## Entidades principales

### Usuario

Opcional en la primera versión local. Será más importante cuando exista sincronización.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador local estable. |
| `nombre` | text nullable | Nombre visible del usuario. |
| `email` | text nullable | Correo si existe cuenta futura. |
| `createdAt` | datetime | Fecha de creación. |
| `updatedAt` | datetime | Fecha de última actualización. |

### Actividad

Tabla principal del sistema.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador local estable. |
| `usuarioId` | text nullable | Relación futura con usuario. |
| `tipo` | text/enum | Tarea, recordatorio, evento, rutina o tarea mensual. |
| `titulo` | text | Nombre principal. |
| `descripcion` | text nullable | Nota o detalle adicional. |
| `estado` | text/enum | Pendiente o completada en el MVP. Cancelada queda como opción futura si existe cancelación explícita. |
| `urgente` | boolean | Marca urgente opcional. |
| `categoriaId` | text nullable | Categoría asociada en versión intermedia. |
| `fechaLimite` | datetime nullable | Fecha límite para tareas u obligaciones. |
| `fechaInicio` | datetime nullable | Inicio de evento o intervalo activo. |
| `fechaFin` | datetime nullable | Fin de evento o intervalo activo. |
| `fechaAviso` | datetime nullable | Fecha y hora principal de aviso. |
| `duracionEstimadaMin` | integer nullable | Duración estimada en minutos, versión intermedia. |
| `ubicacionTexto` | text nullable | Ubicación escrita manualmente, versión intermedia. |
| `createdAt` | datetime | Fecha de creación. |
| `updatedAt` | datetime | Fecha de actualización. |
| `deletedAt` | datetime nullable | Borrado lógico interno para sincronización futura, no como archivado visible inicial. |
| `syncStatus` | text nullable | Pendiente, sincronizado o conflicto en versión futura. |

### Categoría

Entidad de versión intermedia.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `nombre` | text | Ejemplo: estudio, trabajo, salud, pagos, hogar o personal. |
| `colorHex` | text | Color asociado. |
| `orden` | integer | Orden visual opcional. |
| `createdAt` | datetime | Fecha de creación. |
| `updatedAt` | datetime | Fecha de actualización. |

### Repetición

Define cómo se repite una actividad.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `actividadId` | text | Actividad relacionada. |
| `tipo` | text/enum | Diaria, semanal, mensual, anual o personalizada. |
| `intervalo` | integer | Cada cuántos días, semanas, meses o años. |
| `diasSemana` | text/json nullable | Días aplicables para rutinas semanales. |
| `diaMes` | integer nullable | Día del mes deseado para tareas mensuales. |
| `fechaInicio` | date nullable | Inicio de la regla. |
| `fechaFin` | date nullable | Fin opcional de la regla. |
| `reglaTexto` | text nullable | Representación legible o futura regla avanzada. |

Regla para tareas mensuales: si `diaMes` no existe en un mes, la ocurrencia debe programarse para el último día disponible de ese mes. Por ejemplo, una tarea configurada para el día 31 se programará el 28 o 29 de febrero según corresponda.

### OcurrenciaActividad

Representa una fecha concreta generada por una actividad recurrente o programada. Es necesaria para manejar rutinas, tareas mensuales y acciones sobre repeticiones individuales.

Sirve para:

- Marcar una rutina como completada solo en un día específico.
- Marcar una tarea mensual como completada solo en un mes específico.
- Saltar una repetición sin eliminar la actividad completa.
- Posponer una ocurrencia concreta.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `actividadId` | text | Actividad que genera la ocurrencia. |
| `fechaProgramada` | datetime | Fecha y hora programada de la ocurrencia. |
| `estadoOcurrencia` | text/enum | Pendiente, completada, saltada o pospuesta. |
| `completedAt` | datetime nullable | Fecha en que se completó la ocurrencia. |
| `skippedAt` | datetime nullable | Fecha en que se saltó la ocurrencia. |
| `postponedTo` | datetime nullable | Nueva fecha/hora si la ocurrencia fue pospuesta. |
| `createdAt` | datetime | Fecha de creación. |
| `updatedAt` | datetime | Fecha de actualización. |

Notas:

- Para una rutina diaria, cada día aplicable puede tener una ocurrencia.
- Para una tarea mensual, cada mes aplicable puede tener una ocurrencia.
- Una ocurrencia vencida se calcula cuando `estadoOcurrencia` es `pendiente` y `fechaProgramada` ya pasó.
- La generación puede ser materializada por rango cercano o calculada bajo demanda, pero las ocurrencias modificadas por el usuario deben persistirse.

### NotificaciónProgramada

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `actividadId` | text | Actividad relacionada. |
| `ocurrenciaId` | text nullable | Ocurrencia concreta relacionada, si aplica. |
| `fechaHora` | datetime | Momento programado. |
| `tipo` | text/enum | Principal, anticipada, repetida o persistente. |
| `estado` | text/enum | Programada, enviada, cancelada o fallida. |
| `payload` | text/json nullable | Datos necesarios para abrir la actividad. |
| `createdAt` | datetime | Fecha de creación. |

### HistorialActividad

Registra cambios relevantes sin convertir la app en un sistema estadístico.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `actividadId` | text nullable | Actividad relacionada. Puede ser nullable si la actividad fue eliminada. |
| `ocurrenciaId` | text nullable | Ocurrencia relacionada cuando el cambio afecta una repetición concreta. |
| `accion` | text/enum | Creada, editada, completada, reprogramada, pospuesta, saltada, cancelada o eliminada. |
| `detalle` | text/json nullable | Datos resumidos del cambio. |
| `fechaHora` | datetime | Momento del evento. |

### EnlaceActividad

Entidad de versión intermedia.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `actividadId` | text | Actividad relacionada. |
| `url` | text | Enlace completo. |
| `plataforma` | text nullable | Meet, Zoom, Drive, Docs, YouTube, mapas u otra. |
| `tituloDetectado` | text nullable | Texto sugerido para botón, por ejemplo Abrir Meet. |
| `createdAt` | datetime | Fecha de creación. |

### ConfiguraciónUsuario

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `usuarioId` | text nullable | Usuario relacionado en versión futura. |
| `clave` | text | Nombre de la configuración. |
| `valor` | text/json | Valor serializado. |
| `updatedAt` | datetime | Última actualización. |

Ejemplos de configuración:

- Tiempo predeterminado para posponer.
- Aviso anticipado por defecto.
- Tipo de vista inicial.
- Valores predeterminados para nuevas actividades.
- Preferencias de resumen diario.

### EjemploAprendizajeLocal

Entidad futura para guardar correcciones del usuario.

| Campo | Tipo sugerido | Descripción |
|---|---|---|
| `id` | text/uuid | Identificador. |
| `textoOriginal` | text | Frase ingresada o transcrita. |
| `resultadoDetectado` | text/json | Datos detectados inicialmente. |
| `resultadoCorregido` | text/json | Datos finales corregidos por el usuario. |
| `tipoCorregido` | text/enum nullable | Tipo final elegido por el usuario. |
| `createdAt` | datetime | Fecha del ejemplo. |
| `usadoParaEntrenamientoLocal` | boolean | Indica si fue usado en un proceso local futuro. |

## Relaciones

| Relación | Tipo | Descripción |
|---|---|---|
| Usuario - Actividad | 1 a N | Un usuario puede tener muchas actividades. Opcional en MVP. |
| Categoría - Actividad | 1 a N | Una categoría puede agrupar muchas actividades en versión intermedia. |
| Actividad - Repetición | 1 a 0..1 | Una actividad puede tener una regla de repetición. |
| Actividad - OcurrenciaActividad | 1 a N | Una actividad recurrente o programada puede tener varias ocurrencias concretas. |
| Actividad - NotificaciónProgramada | 1 a N | Una actividad puede tener varias notificaciones. |
| OcurrenciaActividad - NotificaciónProgramada | 1 a N | Una ocurrencia puede tener notificaciones propias cuando aplique. |
| Actividad - HistorialActividad | 1 a N | Una actividad puede tener varios eventos de historial. |
| OcurrenciaActividad - HistorialActividad | 1 a N | Una ocurrencia puede registrar acciones como completada, saltada o pospuesta. |
| Actividad - EnlaceActividad | 1 a N | Una actividad puede tener varios enlaces en versión intermedia. |

## Consideraciones para SQLite/Drift

- Usar UUID o identificadores de texto para facilitar sincronización futura.
- Definir enums en Dart y mapearlos a texto o enteros.
- Crear índices para `tipo`, `estado`, `fechaLimite`, `fechaInicio`, `fechaAviso`, `categoriaId`, `updatedAt`, `actividadId`, `fechaProgramada` y `estadoOcurrencia`.
- Usar migraciones de Drift desde el primer cambio de esquema.
- Mantener reglas de validación por tipo en la capa de dominio, no solo en la base.
- Evitar guardar listas complejas en texto cuando una relación normalizada sea más útil.
- Usar JSON solo para datos flexibles o futuros, como detalles de historial o configuraciones.
- Preparar consultas específicas para Hoy, Próximas, Vencidas, Agenda y Calendario.
- Calcular vencimiento en consultas o servicios de dominio a partir de fechas y estados pendientes.
- Persistir ocurrencias modificadas por el usuario para no perder completados, saltos o posposiciones.

## Consideraciones para sincronización futura

- Cada entidad importante debe tener `id`, `createdAt` y `updatedAt`.
- Para sincronización, agregar campos como `syncStatus`, `remoteId`, `version` o `lastSyncedAt` cuando se implemente.
- Considerar borrado lógico interno con `deletedAt` para sincronizar eliminaciones.
- Resolver conflictos con una regla clara: por ejemplo, última actualización gana solo para campos simples, y resolución manual para conflictos importantes.
- Las ocurrencias completadas, saltadas o pospuestas deben sincronizarse como cambios propios, no como cambios globales de toda la actividad.
- La app debe seguir siendo funcional aunque la sincronización falle.
