# Plan de pruebas

## Objetivo del plan

Validar que Remember To.App permita gestionar actividades personales de forma confiable, especialmente en funcionamiento local, notificaciones, vistas de calendario/agenda y flujos de confirmación.

## Alcance de pruebas

Incluye:

- Registro, edición, eliminación y consulta de actividades.
- Tareas, recordatorios, eventos, rutinas y tareas mensuales.
- Estados base principales del MVP: pendiente y completada.
- Estado cancelada solo como opción futura si se implementa cancelación explícita.
- Condición vencida calculada a partir de fecha/hora y estado pendiente.
- Reprogramación como acción registrada en historial.
- Ocurrencias para rutinas, tareas mensuales, saltos y posposiciones.
- Funcionamiento sin conexión.
- Notificaciones locales básicas y acciones de notificación en versión intermedia.
- Calendario, agenda, Hoy y Próximas.
- Categorías y enlaces inteligentes en versión intermedia.
- Voz e interpretación local en versión avanzada.
- Sincronización futura.

No incluye por ahora:

- Pruebas de IA pagada.
- Estadísticas.
- Checklist.
- Bloqueo biométrico o PIN.
- Recordatorios por ubicación.

## Pruebas funcionales

Se deben validar los flujos principales de creación, edición, eliminación, completado, reprogramación, posposición, búsqueda y filtros por tipo.

Para actividades recurrentes, las pruebas deben distinguir entre cambios sobre la actividad principal y cambios sobre una ocurrencia concreta.

La duración estimada se prueba como función de versión intermedia. Puede aportar datos para una futura detección de conflictos, pero no implica que la detección de conflictos forme parte de la versión intermedia.

## Pruebas de notificaciones

Se deben probar:

- Solicitud de permisos.
- Programación de avisos.
- Cancelación de avisos al completar o eliminar.
- Reprogramación de avisos al editar.
- Notificaciones anticipadas.
- Repetición de notificación si una actividad no se marca como completada.
- Acciones desde notificación: completar y posponer.
- Reconstrucción de notificaciones tras reinicio cuando el sistema operativo lo permita.
- Comportamiento ante restricciones de Android.

Android puede limitar notificaciones, alarmas exactas, ejecución en segundo plano o notificaciones persistentes. Las pruebas no deben asumir que una notificación será imborrable o 100% exacta en todos los dispositivos.

## Pruebas offline

Se deben validar operaciones sin internet:

- Crear actividad.
- Editar actividad.
- Marcar como completada.
- Completar, saltar o posponer una ocurrencia.
- Consultar Hoy, Próximas, Vencidas, Calendario y Agenda.
- Guardar historial.
- Guardar configuración local.

## Pruebas de calendario y agenda

Se deben probar:

- Visualización diaria, semanal y mensual.
- Orden por fecha y hora.
- Eventos con inicio y fin.
- Rutinas y tareas mensuales calculadas para el día correspondiente.
- Actividades sin fecha fuera de vistas temporales estrictas.
- Tareas mensuales configuradas para días que no existen en todos los meses.

## Pruebas de enlaces inteligentes

Se deben probar en versión intermedia:

- Detección de Meet, Zoom, Drive, Docs y YouTube.
- Botón de apertura.
- Visualización del enlace completo.
- Copia manual si el acceso directo falla.
- Enlaces genéricos no reconocidos.

## Pruebas de voz futuras

Se deben probar cuando la función exista:

- Entrada por texto.
- Entrada por voz.
- Transcripción local o gratuita.
- Detección de tipo.
- Detección de fecha, hora y repetición.
- Vista previa obligatoria.
- Corrección antes de guardar.
- Guardado de ejemplos de aprendizaje local.

## Pruebas de sincronización futuras

Se deben probar cuando la función exista:

- Cola de cambios locales.
- Sincronización al recuperar conexión.
- Conflictos simples.
- Eliminaciones sincronizadas.
- Ocurrencias completadas, saltadas o pospuestas.
- Funcionamiento local durante fallos de red.

## Casos de prueba

| Código | Escenario | Pasos | Resultado esperado |
|---|---|---|---|
| CP-01 | Crear tarea sin fecha límite | Crear tarea con título y sin fecha límite. | La tarea se guarda y no aparece como vencida. |
| CP-02 | Crear tarea urgente | Crear tarea y activar marca urgente. | La tarea aparece con indicador urgente. |
| CP-03 | Completar tarea | Crear tarea pendiente y marcarla como completada. | El estado base cambia a completada y se registra en historial. |
| CP-04 | Crear recordatorio | Crear recordatorio con fecha y hora futura. | Se guarda y se programa notificación si hay permisos. |
| CP-05 | Recordatorio sin hora | Intentar guardar recordatorio sin hora. | El sistema solicita completar la hora. |
| CP-06 | Crear evento válido | Crear evento con inicio antes del fin. | El evento se guarda y aparece en calendario/agenda. |
| CP-07 | Crear evento inválido | Crear evento con fin antes del inicio. | El sistema impide guardar y solicita corrección. |
| CP-08 | Crear rutina semanal | Crear rutina de lunes a viernes. | La rutina genera o calcula ocurrencias solo en los días configurados. |
| CP-09 | Cumplir rutina | Marcar rutina como realizada en el día actual. | Solo la ocurrencia del día queda completada. |
| CP-10 | Crear tarea mensual | Crear tarea mensual para el día 30. | Se calcula la siguiente ocurrencia mensual. |
| CP-11 | Completar tarea mensual | Completar tarea mensual del mes actual. | La ocurrencia del mes actual queda completada y la repetición sigue activa. |
| CP-12 | Ver Hoy | Crear actividades para el día actual y abrir Hoy. | Se muestran las actividades y ocurrencias del día con su estado. |
| CP-13 | Ver Próximas | Crear actividades futuras y abrir Próximas. | Se muestran ordenadas por fecha y hora. |
| CP-14 | Ver Vencidas | Dejar pendiente una actividad con fecha pasada. | Aparece como vencida calculada, sin cambiar su estado base persistente. |
| CP-15 | Actividad sin fecha no vencida | Crear tarea sin fecha y revisar Vencidas. | No aparece como vencida. |
| CP-16 | Editar actividad | Cambiar título, fecha o categoría si está disponible desde versión intermedia. | Los cambios se guardan y el historial registra edición. |
| CP-17 | Eliminar con confirmación | Intentar eliminar una actividad. | El sistema solicita confirmación antes de eliminar. |
| CP-18 | Cancelar eliminación | Cancelar la confirmación de eliminación. | La actividad permanece intacta. |
| CP-19 | Filtrar por tipo | Crear varios tipos y aplicar filtro. | Solo aparecen actividades del tipo seleccionado. |
| CP-20 | Categoría con color | Crear categoría y asignarla a actividad en versión intermedia. | La actividad muestra la categoría y color definidos. |
| CP-21 | Enlace Meet | Agregar enlace de Meet. | Se muestra botón Abrir Meet y enlace completo. |
| CP-22 | Enlace no reconocido | Agregar enlace genérico. | Se guarda como enlace genérico y se muestra completo. |
| CP-23 | Posponer actividad | Posponer una actividad u ocurrencia programada. | Se actualiza la hora y se reprograma notificación si corresponde. |
| CP-24 | Trabajar sin conexión | Desactivar internet y crear/editar/completar actividades. | Todas las operaciones principales funcionan localmente. |
| CP-25 | Permisos de notificación | Instalar app sin permisos y crear recordatorio. | El sistema solicita u orienta sobre permisos. |
| CP-26 | Aviso anticipado | Configurar un aviso antes de la hora principal. | El sistema programa el aviso anticipado si el sistema operativo lo permite. |
| CP-27 | Repetir notificación si no se marca | Dejar pendiente una actividad notificada. | El sistema intenta repetir el aviso según configuración y límites de Android. |
| CP-28 | Texto detectado futuro | Ingresar "estudiar redes mañana". | El sistema muestra vista previa antes de guardar. |
| CP-29 | Corregir detección futura | Cambiar tipo o fecha en la vista previa. | La actividad se guarda con datos corregidos. |
| CP-30 | Guardar aprendizaje local futuro | Confirmar una actividad corregida. | Se guarda un ejemplo local de corrección. |
| CP-31 | Sincronización futura sin conexión | Crear cambios sin internet en versión con nube. | Los cambios quedan pendientes localmente. |
| CP-32 | Sincronización futura con conexión | Recuperar conexión con cambios pendientes. | El sistema sincroniza sin bloquear el uso local. |
| CP-33 | Definir duración estimada | Crear o editar actividad e ingresar duración válida. | La duración queda guardada y puede usarse en agenda. |
| CP-34 | Detectar conflicto de horario | Crear actividad con horario que cruza otra existente. | El sistema muestra advertencia de conflicto. |
| CP-35 | Saltar una repetición | Seleccionar una ocurrencia pendiente y saltarla. | La ocurrencia queda en estado saltada y la actividad principal sigue activa. |
| CP-36 | Configurar valor predeterminado | Definir un valor por defecto para nuevas actividades. | El nuevo formulario usa ese valor automáticamente. |
| CP-37 | Agregar ubicación opcional | Editar actividad e ingresar una ubicación manual. | La ubicación se guarda como texto sin requerir permisos de ubicación. |
| CP-38 | Abrir ubicación en mapas | Seleccionar abrir en mapas desde actividad con ubicación. | El sistema intenta abrir una aplicación de mapas o mantiene el texto copiable. |
| CP-39 | Completar desde notificación | Usar acción de completar en notificación. | La actividad u ocurrencia queda completada si Android permite la acción. |
| CP-40 | Posponer desde notificación | Usar acción de posponer en notificación. | La actividad u ocurrencia queda aplazada y con nuevo aviso si corresponde. |
| CP-41 | Reconstruir notificaciones tras reinicio | Simular reinicio o reconstrucción de programación. | La app reconstruye avisos pendientes cuando el sistema operativo lo permite. |
| CP-42 | Tarea mensual con día inexistente | Crear tarea mensual para día 31 y calcular febrero. | La ocurrencia se programa para el 28 o 29 de febrero según corresponda. |
