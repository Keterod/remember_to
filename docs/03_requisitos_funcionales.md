# Requisitos funcionales

Este documento organiza los requisitos funcionales aceptados para Remember To.App. Las prioridades y versiones sugeridas ayudan a planificar el desarrollo, pero pueden ajustarse durante los sprints.

## Usuarios

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-01 | Registrar usuario | El sistema debe permitir registrar un usuario para guardar su información personal. Puede ser opcional en la primera versión si el trabajo es local. | Usuarios | Baja | Intermedia |
| RF-02 | Iniciar sesión | El sistema debe permitir iniciar sesión si se implementa sincronización o cuentas de usuario. | Usuarios | Futura | Avanzada |

## Actividades generales

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-13 | Editar registros | El sistema debe permitir modificar tareas, recordatorios, eventos, rutinas y tareas mensuales. | Actividades generales | Alta | MVP |
| RF-14 | Eliminar registros | El sistema debe permitir eliminar tareas, recordatorios, eventos, rutinas o tareas mensuales. | Actividades generales | Alta | MVP |
| RF-15 | Confirmar antes de eliminar | El sistema debe solicitar confirmación antes de eliminar cualquier actividad. | Actividades generales | Alta | MVP |
| RF-16 | Filtrar actividades por tipo | El sistema debe permitir filtrar por tareas, recordatorios, eventos, rutinas o tareas mensuales. | Actividades generales | Media | MVP |
| RF-20 | Mostrar estado de cumplimiento | El sistema debe mostrar los estados base principales del MVP: pendiente y completada. En la lista de recordatorios debe verse «Pendiente» o «Atendido» según corresponda. El estado cancelada queda como opción futura si se implementa cancelación explícita. Las vencidas deben mostrarse como condición calculada y las reprogramaciones como acciones del historial. | Actividades generales | Alta | MVP |
| RF-23 | Marcar actividad como urgente | El sistema debe permitir marcar una actividad como urgente solo cuando el usuario lo indique. | Actividades generales | Media | MVP |
| RF-24 | Buscar actividades | El sistema debe permitir buscar actividades activas por título o descripción y seleccionar un resultado para abrir la actividad correspondiente en modo consulta o edición. La búsqueda excluye actividades eliminadas, no incluye filtros avanzados ni categorías ni etiquetas. | Actividades generales | Media | Intermedia |
| RF-25 | Ver historial de cumplimiento | El sistema debe permitir consultar actividades completadas, pendientes y acciones anteriores como reprogramaciones, posposiciones o eliminaciones. | Actividades generales | Media | Intermedia |
| RF-26 | Reprogramar actividades | El sistema debe permitir cambiar fecha, hora o repetición de una actividad como parte de la edición. La acción debe quedar registrada en el historial. | Actividades generales | Alta | MVP |
| RF-27 | Posponer actividades | El sistema debe permitir aplazar una actividad u ocurrencia por un tiempo corto o hacia una fecha cercana. | Actividades generales | Media | Intermedia |
| RF-29 | Mostrar actividad reciente | El sistema debe mostrar últimas actividades creadas, editadas, completadas o eliminadas. | Actividades generales | Baja | Intermedia |
| RF-51 | Agregar notas o descripción | El sistema debe permitir agregar notas o descripción adicional a cualquier actividad. | Actividades generales | Alta | MVP |
| RF-60 | Definir duración estimada | El sistema debe permitir asignar duración estimada a tareas, eventos, rutinas o recordatorios. | Actividades generales | Media | Intermedia |
| RF-61 | Detectar conflictos de horario | El sistema debe avisar cuando una actividad se cruce con otra ya registrada. | Actividades generales | Media | Avanzada |
| RF-62 | Saltar una repetición | El sistema debe permitir omitir una ocurrencia específica de una rutina o tarea recurrente sin borrar toda la repetición. | Actividades generales | Media | Intermedia |
| RF-64 | Ordenar actividades y tareas | El sistema debe permitir ordenar actividades por fecha, hora, tipo, estado base, condición calculada de vencimiento y urgencia cuando aplique. | Actividades generales | Media | MVP |
| RF-67 | Agregar ubicación opcional | El sistema debe permitir agregar una ubicación solo si el usuario la especifica manualmente. | Actividades generales | Media | Intermedia |
| RF-68 | Abrir ubicación en mapas | El sistema debe permitir abrir la ubicación registrada en una aplicación de mapas. | Actividades generales | Baja | Intermedia |
| RF-69 | Registrar actividades sin fecha límite | El sistema debe permitir registrar actividades que no tengan fecha definida. Estas actividades no deben aparecer como vencidas. | Actividades generales | Alta | MVP |

**Nota sobre RF-60 y RF-61:** la duración estimada de RF-60 pertenece a la versión intermedia y puede servir como dato de apoyo para detectar conflictos en el futuro. Esto no obliga a implementar RF-61 en la versión intermedia; la detección de conflictos se mantiene como función avanzada.

## Tareas

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-03 | Crear tareas | El sistema debe permitir registrar tareas con título, descripción o nota, fecha límite opcional, estado base y marca urgente opcional. | Tareas | Alta | MVP |
| RF-04 | Marcar tareas como completadas | El sistema debe permitir marcar una tarea como completada o pendiente. | Tareas | Alta | MVP |

## Recordatorios

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-05 | Crear recordatorios | El sistema debe permitir crear recordatorios con título, descripción, fecha y hora de aviso. | Recordatorios | Alta | MVP |
| RF-06 | Notificar recordatorios | El sistema debe enviar una notificación cuando llegue la fecha y hora configurada, considerando las limitaciones del sistema operativo. | Recordatorios | Alta | MVP |

## Eventos

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-07 | Registrar eventos en calendario | El sistema debe permitir guardar eventos con fecha, hora de inicio, hora de fin y descripción. La ubicación opcional queda cubierta por RF-67 en versión intermedia. | Eventos | Alta | MVP |

## Rutinas

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-09 | Crear rutinas | El sistema debe permitir registrar rutinas indicando los días o frecuencia en que se repiten. | Rutinas | Alta | MVP |
| RF-10 | Marcar cumplimiento de rutinas | El sistema debe permitir marcar si una rutina fue realizada en una fecha específica mediante una ocurrencia de actividad. | Rutinas | Alta | MVP |

## Tareas mensuales

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-11 | Crear tareas mensuales | El sistema debe permitir registrar tareas que se repiten cada mes en una fecha específica. Si el día configurado no existe en un mes, se programará para el último día disponible de ese mes. | Tareas mensuales | Alta | MVP |
| RF-12 | Marcar tareas mensuales como completadas | El sistema debe permitir marcar una tarea mensual como realizada para un mes específico mediante una ocurrencia, sin eliminar su repetición para el siguiente mes. | Tareas mensuales | Alta | MVP |

## Calendario y agenda

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-08 | Visualizar calendario | El sistema debe mostrar actividades en una vista de calendario diaria, semanal o mensual básica. | Calendario y agenda | Alta | MVP |
| RF-17 | Mostrar actividades del día | El sistema debe mostrar una sección Hoy con todas las actividades programadas para el día actual. | Calendario y agenda | Alta | MVP |
| RF-18 | Mostrar próximas actividades | El sistema debe mostrar actividades futuras ordenadas por fecha y hora. | Calendario y agenda | Alta | MVP |
| RF-19 | Mostrar actividades vencidas | El sistema debe mostrar actividades u ocurrencias pendientes cuya fecha u hora ya pasó. La condición vencida debe calcularse, no guardarse como estado persistente principal. | Calendario y agenda | Alta | MVP |
| RF-65 | Mostrar vista de agenda | El sistema debe mostrar una vista tipo agenda con actividades organizadas por día y hora. | Calendario y agenda | Alta | MVP |

## Notificaciones

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-36 | Configurar recordatorios anticipados | El sistema debe permitir configurar avisos antes de la hora principal. | Notificaciones | Media | Intermedia |
| RF-38 | Mostrar notificación persistente durante actividad activa | El sistema debe mostrar una notificación persistente mientras una actividad esté dentro de su intervalo activo, siempre que el sistema operativo lo permita. No debe prometerse que sea imborrable o exacta en todos los dispositivos. | Notificaciones | Media | Avanzada |
| RF-55 | Personalizar notificaciones por tipo | El sistema debe permitir configurar tiempos de notificación diferentes según tipo de actividad. | Notificaciones | Media | Intermedia |
| RF-56 | Notificar nuevamente si no se marca | El sistema debe repetir una notificación cuando una actividad u ocurrencia siga pendiente tras el aviso principal, con un máximo razonable de intentos (p. ej. 3) e intervalo fijo (p. ej. 10 min), sin repetición indefinida. Las repeticiones deben ofrecer las mismas acciones (Listo/Completar y posponer). Usa fallback inexacto si Android restringe alarmas exactas. | Notificaciones | Alta | Intermedia |
| RF-57 | Completar desde notificación | El sistema debe permitir completar o marcar como atendido desde la notificación sin abrir la app (acción en segundo plano con `showsUserInterface: false`). En recordatorios el botón visible es «Listo». Si la acción falla, la UI debe seguir permitiendo completar. Cancela avisos futuros relacionados. | Notificaciones | Alta | Intermedia |
| RF-58 | Posponer desde notificación | El sistema debe permitir posponer (10, 30 o 60 min) sin abrir la app, reprogramando el aviso y actualizando la fecha visible en la lista de recordatorios (y `postponedTo` en ocurrencias cuando aplique). | Notificaciones | Alta | Intermedia |
| RF-66 | Solicitar permisos necesarios | El sistema debe solicitar y orientar al usuario para activar permisos de notificaciones, alarmas y ejecución en segundo plano. | Notificaciones | Alta | MVP |

**Nota sobre RF-39:** el requisito original "Mantener actividad visible durante su intervalo" queda integrado como criterio de aceptación de RF-38 para evitar duplicidad.

## Categorías

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-21 | Crear categorías personalizadas | El sistema debe permitir crear categorías como estudio, trabajo, salud, pagos, hogar o personal. | Categorías | Media | Intermedia |
| RF-22 | Asignar colores por categoría | El sistema debe permitir asignar colores a categorías para diferenciarlas visualmente. | Categorías | Media | Intermedia |

**Nota:** las categorías no forman parte del MVP. Se implementan desde la versión intermedia.

## Enlaces inteligentes

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-52 | Agregar enlaces inteligentes | El sistema debe permitir agregar enlaces relacionados a una actividad y mostrarlos como accesos directos según la plataforma. | Enlaces inteligentes | Media | Intermedia |
| RF-53 | Detectar plataformas desde enlaces | El sistema debe identificar enlaces de Meet, Zoom, Drive, Docs, YouTube u otros servicios. | Enlaces inteligentes | Media | Intermedia |
| RF-54 | Mostrar botón y enlace completo | El sistema debe mostrar un botón como Abrir Meet o Abrir Zoom y también mostrar el enlace completo debajo para copiarlo si el botón falla. | Enlaces inteligentes | Media | Intermedia |

## Voz e interpretación local

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-43 | Registrar actividades mediante voz | El sistema debe permitir registrar actividades mediante comandos de voz en una versión futura. | Voz e interpretación local | Futura | Avanzada |
| RF-44 | Transcribir voz a texto | El sistema debe convertir audio del usuario en texto usando opciones locales o gratuitas. | Voz e interpretación local | Futura | Avanzada |
| RF-45 | Interpretar intención | El sistema debe analizar el texto para identificar si el usuario quiere crear tarea, recordatorio, evento, rutina o tarea mensual. | Voz e interpretación local | Futura | Avanzada |
| RF-46 | Extraer datos desde texto o voz | El sistema debe identificar título, fecha, hora, repetición y tipo de actividad cuando sea posible. | Voz e interpretación local | Futura | Avanzada |
| RF-47 | Confirmar antes de guardar actividad detectada | El sistema debe mostrar una vista previa de la actividad detectada por texto o voz antes de guardarla. | Voz e interpretación local | Futura | Avanzada |
| RF-48 | Corregir actividad detectada | El sistema debe permitir corregir tipo, título, fecha, hora, repetición, urgencia y categoría antes de guardar una actividad detectada por texto o voz. | Voz e interpretación local | Futura | Avanzada |
| RF-49 | Guardar correcciones como aprendizaje local | El sistema debe guardar correcciones realizadas por el usuario para mejorar futuras clasificaciones locales. | Voz e interpretación local | Futura | Avanzada |
| RF-50 | Detectar fechas y horas simples | El sistema debe detectar expresiones como "mañana", "hoy", "el lunes", "a las 5", "cada viernes" o "cada mes". | Voz e interpretación local | Futura | Avanzada |

## Datos y sincronización

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-30 | Guardar datos localmente | El sistema debe almacenar localmente tareas, recordatorios, eventos, rutinas, tareas mensuales, historial y configuración. | Datos y sincronización | Alta | MVP |
| RF-31 | Funcionar sin conexión | El sistema debe permitir crear, editar, consultar y marcar actividades sin internet. | Datos y sincronización | Alta | MVP |
| RF-32 | Sincronizar datos con la nube | El sistema debe permitir sincronizar datos con una base de datos en la nube cuando exista conexión. Esta función queda para versión futura. | Datos y sincronización | Futura | Avanzada |
| RF-33 | Sincronización automática | El sistema debe guardar datos localmente y sincronizarlos automáticamente cuando recupere conexión. | Datos y sincronización | Futura | Avanzada |
| RF-34 | Respaldar información | El sistema debe permitir respaldar datos para evitar pérdida de información. | Datos y sincronización | Media | Intermedia |
| RF-59 | Importar y exportar datos | El sistema debe permitir importar y exportar datos como copia de seguridad. Prioridad secundaria. | Datos y sincronización | Baja | Intermedia |

## Configuración

| Código | Nombre del requisito | Descripción | Módulo | Prioridad | Versión sugerida |
|---|---|---|---|---|---|
| RF-28 | Generar resumen diario configurable | El sistema debe mostrar un resumen diario con actividades pendientes, completadas y próximas. | Configuración | Media | Intermedia |
| RF-35 | Configurar repetición personalizada | El sistema debe permitir definir repeticiones diarias, semanales, mensuales, anuales o personalizadas. | Configuración | Media | Intermedia |
| RF-37 | Crear plantillas de actividades | El sistema debe permitir crear plantillas para actividades repetidas. | Configuración | Baja | Intermedia |
| RF-40 | Agregar widgets de inicio | El sistema debe permitir agregar widgets en la pantalla principal del dispositivo para visualizar información rápida. Queda para versión avanzada. | Configuración | Futura | Avanzada |
| RF-41 | Widget de calendario | El sistema debe mostrar un widget con actividades del día o semana. Queda para versión avanzada. | Configuración | Futura | Avanzada |
| RF-42 | Widget de pendientes | El sistema debe mostrar un widget con actividades pendientes próximas. Queda para versión avanzada. | Configuración | Futura | Avanzada |
| RF-63 | Configurar valores predeterminados | El sistema debe permitir definir valores por defecto para nuevas actividades. | Configuración | Media | Intermedia |
