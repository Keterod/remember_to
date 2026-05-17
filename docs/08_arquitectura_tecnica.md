# Arquitectura técnica inicial

La arquitectura propuesta busca iniciar simple, pero con separación suficiente para crecer hacia escritorio, sincronización futura y voz con interpretación local.

## Capas recomendadas

| Capa | Responsabilidad |
|---|---|
| Presentation/UI | Pantallas, componentes visuales, navegación y formularios. |
| State management | Estado de pantallas, filtros, formularios y carga de datos. Se usará Riverpod como gestor inicial. |
| Domain | Entidades de negocio, validaciones, casos de uso y reglas por tipo de actividad. |
| Data | Repositorios, modelos de persistencia y adaptadores. |
| Local database | SQLite/Drift, migraciones y consultas locales. |
| Services | Servicios de fecha, enlaces, permisos, ubicación manual y utilidades. |
| Notifications | Programación, cancelación y respuesta a notificaciones locales. |
| Sync | Sincronización futura con nube, resolución de conflictos y cola de cambios. |
| Voice/ML future | Transcripción, reglas locales, clasificador local y aprendizaje con correcciones. |

## Estructura de carpetas sugerida

```text
lib/
  app/
    app.dart
    router/
    theme/
  core/
    constants/
    errors/
    utils/
    time/
  features/
    activities/
      presentation/
      application/
      domain/
      data/
    tasks/
    reminders/
    events/
    routines/
    monthly_tasks/
    calendar/
    agenda/
    categories/
    notifications/
    smart_links/
    settings/
    history/
    voice_input/
    sync/
  shared/
    widgets/
    models/
    services/
```

La separación por `features` ayuda a mantener módulos claros. Sin embargo, como todas las actividades comparten comportamiento, el módulo `activities` debe contener la lógica común y los demás módulos deben especializar solo lo necesario.

## Tecnologías recomendadas

| Área | Recomendación |
|---|---|
| Framework | Flutter |
| Lenguaje | Dart |
| Base local | SQLite con Drift |
| Estado | Riverpod como gestor de estado inicial. |
| Navegación | go_router |
| Notificaciones | flutter_local_notifications |
| Zonas horarias | timezone |
| Fechas e internacionalización | intl |
| Calendario | table_calendar o componente propio simple al inicio |
| Enlaces externos | url_launcher |
| Archivos y rutas locales | path_provider |
| Exportación futura | csv, archive o generación JSON controlada |
| Voz futura | Vosk offline o speech_to_text, según viabilidad real en Flutter |

Riverpod se adopta como decisión inicial porque es suficiente para iniciar, mantiene buena separación de estado y puede escalar sin agregar complejidad innecesaria. Bloc queda como alternativa futura no elegida para el arranque del proyecto.

## Dependencias candidatas

Estas dependencias son candidatas, no decisiones definitivas de instalación inmediata:

- `drift`
- `drift_flutter`
- `sqlite3_flutter_libs`
- `path_provider`
- `flutter_riverpod`
- `go_router`
- `flutter_local_notifications`
- `timezone`
- `intl`
- `table_calendar`
- `url_launcher`
- `permission_handler`
- `connectivity_plus`

Antes de implementar, conviene revisar compatibilidad actual, mantenimiento y soporte para Android.

## Flujo de datos

1. La UI solicita una acción, por ejemplo crear actividad.
2. Un provider de Riverpod gestiona el estado del formulario o vista.
3. El caso de uso de dominio aplica reglas por tipo.
4. El repositorio guarda en la base local.
5. El servicio de notificaciones programa o actualiza avisos si corresponde.
6. La UI observa los cambios desde providers o streams.
7. El historial registra acciones relevantes.

## Manejo offline-first

La base local es la fuente principal de verdad en la primera versión.

Principios:

- No depender de internet para funciones principales.
- Guardar primero localmente.
- Consultar siempre desde la base local.
- Preparar una cola de cambios para sincronización futura.
- Evitar que errores de red afecten creación, edición o consulta local.

## Notificaciones

Las notificaciones locales deben tratarse como una parte crítica del sistema, pero siempre considerando las restricciones reales de Android.

Responsabilidades del módulo:

- Solicitar permisos necesarios.
- Programar avisos de recordatorios y actividades.
- Cancelar avisos cuando una actividad se completa o elimina.
- Reprogramar avisos cuando cambia la fecha u hora.
- Reprogramar avisos de ocurrencias concretas cuando se posponen.
- Reconstruir programaciones después de reinicio o actualización, si el sistema operativo lo permite.
- Manejar acciones futuras como completar o posponer desde notificación.
- Informar limitaciones de alarmas exactas, ejecución en segundo plano y notificaciones persistentes.

La aplicación no debe prometer que una notificación será imborrable ni 100% exacta en todos los dispositivos.

## Sincronización futura

La sincronización debe agregarse sin reemplazar el modelo offline-first.

Componentes futuros:

- Cola de cambios locales.
- Adaptador de nube.
- Identificadores remotos.
- Estado de sincronización por entidad.
- Resolución de conflictos.
- Sincronización automática al recuperar conexión.

La app debe seguir funcionando aunque la nube falle.

## Voz e interpretación futura

Flujo previsto:

```text
Usuario habla
  -> Vosk offline o speech_to_text
  -> texto transcrito
  -> reglas locales
  -> clasificador ML local
  -> confirmación del usuario
  -> guardar actividad
  -> guardar correcciones como ejemplos locales
```

Reglas iniciales sugeridas:

- Detectar expresiones simples: hoy, mañana, el lunes, a las 5, cada viernes, cada mes.
- Detectar intenciones probables: tarea, recordatorio, evento, rutina o tarea mensual.
- Nunca guardar automáticamente sin confirmación.
- Si el tipo no es claro, pedir selección antes de guardar.
- Guardar correcciones para aprendizaje local futuro.

## Criterios arquitectónicos clave

- El dominio no debe depender de Flutter UI.
- La base local no debe contener reglas de negocio complejas.
- Las pantallas no deben construir SQL ni manipular Drift directamente.
- Las notificaciones deben reaccionar a cambios del dominio.
- Las ocurrencias deben permitir completar, saltar o posponer repeticiones concretas sin modificar toda la actividad recurrente.
- El módulo de voz futuro debe terminar siempre en el mismo flujo de confirmación y guardado que el registro manual.
