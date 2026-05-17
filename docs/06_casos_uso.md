# Casos de uso

## CU-01: Crear actividad

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite crear una actividad seleccionando su tipo: tarea, recordatorio, evento, rutina o tarea mensual. |
| Precondiciones | La aplicación está abierta y la base local está disponible. |
| Postcondiciones | La actividad queda guardada localmente con un tipo definido. |

**Flujo principal**

1. El usuario inicia la creación de una actividad.
2. El sistema muestra los tipos disponibles.
3. El usuario selecciona el tipo.
4. El sistema muestra los campos correspondientes.
5. El usuario completa los datos requeridos y opcionales.
6. El sistema valida la información.
7. El sistema guarda la actividad.
8. El sistema registra el evento en historial.

**Flujos alternativos**

- Si faltan datos obligatorios, el sistema solicita completarlos.
- Si el usuario cancela, no se guarda ningún registro.
- Si hay notificaciones asociadas, el sistema las programa después de guardar cuando los permisos lo permitan.

## CU-02: Crear recordatorio

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite crear un aviso con fecha y hora específica. |
| Precondiciones | El usuario tiene acceso al formulario de recordatorio. |
| Postcondiciones | El recordatorio queda guardado y su notificación queda programada si hay permisos. |

**Flujo principal**

1. El usuario selecciona crear recordatorio.
2. Ingresa título, descripción opcional, fecha y hora de aviso.
3. El sistema valida la fecha y hora.
4. El sistema guarda el recordatorio.
5. El sistema programa la notificación local si el sistema operativo lo permite.

**Flujos alternativos**

- Si no hay permisos de notificación, el sistema orienta al usuario para activarlos.
- Si la fecha y hora están en el pasado, el sistema solicita corregirlas o confirmar una reprogramación válida.
- Si Android limita alarmas exactas o segundo plano, el sistema no debe prometer exactitud total.

## CU-03: Crear evento

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite registrar una actividad de calendario con inicio y fin. |
| Precondiciones | La aplicación está disponible y el usuario entra al flujo de evento. |
| Postcondiciones | El evento aparece en calendario y agenda. |

**Flujo principal**

1. El usuario selecciona crear evento.
2. Ingresa título, fecha, hora de inicio y hora de fin.
3. Agrega descripción opcional.
4. El sistema valida que el intervalo sea correcto.
5. El sistema guarda el evento.
6. El sistema lo muestra en calendario y agenda.

**Flujos alternativos**

- Si el horario se cruza con otra actividad, en versión avanzada el sistema muestra una advertencia.
- Si el usuario necesita ubicación, podrá agregarla en una versión intermedia mediante el flujo correspondiente.

## CU-04: Crear rutina

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite crear una actividad repetitiva para días o frecuencias definidas. |
| Precondiciones | El usuario accede al flujo de rutina. |
| Postcondiciones | La rutina queda guardada con regla de repetición. |

**Flujo principal**

1. El usuario selecciona crear rutina.
2. Ingresa título y descripción opcional.
3. Define días o frecuencia de repetición.
4. El sistema valida la regla.
5. El sistema guarda la rutina.
6. El sistema calcula o genera sus ocurrencias según sea necesario.

**Flujos alternativos**

- Si no se define frecuencia, el sistema solicita completarla.
- Si el usuario cancela, no se guarda la rutina.
- Si el usuario completa una rutina, el cambio se aplica a la ocurrencia de la fecha correspondiente.

## CU-05: Crear tarea mensual

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite registrar una obligación que se repite cada mes. |
| Precondiciones | El usuario accede al flujo de tarea mensual. |
| Postcondiciones | La tarea mensual queda activa para los meses siguientes. |

**Flujo principal**

1. El usuario selecciona crear tarea mensual.
2. Ingresa título, descripción opcional y día del mes.
3. El sistema valida el día seleccionado.
4. El sistema guarda la tarea mensual.
5. El sistema calcula la próxima ocurrencia.

**Flujos alternativos**

- Si el día configurado no existe en un mes, el sistema programa la ocurrencia para el último día disponible de ese mes.
- Si el usuario completa el mes actual, se completa solo la ocurrencia del mes y la repetición permanece activa.

## CU-06: Marcar actividad como completada

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite cambiar el estado de una actividad u ocurrencia a completada. |
| Precondiciones | Existe una actividad u ocurrencia pendiente. |
| Postcondiciones | La actividad u ocurrencia queda completada y se registra en historial. |

**Flujo principal**

1. El usuario selecciona una actividad u ocurrencia pendiente.
2. Elige marcar como completada.
3. El sistema actualiza el estado base de la actividad o el estado de la ocurrencia.
4. El sistema registra el cambio en historial.
5. El sistema actualiza las notificaciones asociadas.

**Flujos alternativos**

- Si la actividad es recurrente, solo se completa la ocurrencia correspondiente.
- Si el usuario deshace la acción, el sistema vuelve al estado anterior si esta opción existe.

## CU-07: Posponer actividad

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite aplazar una actividad u ocurrencia por un periodo corto o fecha cercana. |
| Precondiciones | Existe una actividad programada, ocurrencia o notificación. |
| Postcondiciones | La actividad u ocurrencia actualiza su próxima fecha u hora de aviso. |

**Flujo principal**

1. El usuario selecciona posponer desde la app o desde una notificación.
2. El sistema muestra opciones de aplazamiento.
3. El usuario selecciona una opción.
4. El sistema actualiza la actividad u ocurrencia concreta.
5. El sistema reprograma la notificación si corresponde.

**Flujos alternativos**

- Si la notificación no permite acciones por limitación del sistema operativo, el usuario puede posponer desde la app.
- Si el nuevo horario no es válido, el sistema solicita otra opción.

## CU-08: Ver actividades del día

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite consultar actividades programadas para el día actual. |
| Precondiciones | La base local tiene actividades o está disponible para consulta. |
| Postcondiciones | El usuario visualiza las actividades del día con su estado. |

**Flujo principal**

1. El usuario abre la sección Hoy.
2. El sistema consulta actividades con fecha del día actual.
3. El sistema incluye ocurrencias de rutinas y tareas mensuales aplicables.
4. El sistema ordena por hora, tipo o estado según criterio definido.
5. El sistema muestra la lista.

**Flujos alternativos**

- Si no hay actividades, se muestra un estado vacío claro.
- Si hay actividades vencidas del día, se muestran como condición calculada.

## CU-19: Buscar y abrir actividad

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite buscar actividades activas por título o descripción y abrir un resultado en la pantalla de edición correspondiente. |
| Precondiciones | Existen actividades activas en la base local o la búsqueda puede devolver vacío. |
| Postcondiciones | El usuario visualiza coincidencias o un mensaje claro; si selecciona un resultado con tipo reconocido, accede a su edición. |

**Flujo principal**

1. El usuario abre la pantalla de búsqueda.
2. El usuario ingresa un término de búsqueda.
3. El sistema consulta actividades activas por título o descripción, excluyendo eliminadas.
4. El sistema muestra los resultados coincidentes.
5. El usuario selecciona un resultado.
6. El sistema abre la pantalla de edición correspondiente al tipo de actividad.

**Flujos alternativos**

- Si no hay resultados, el sistema muestra un mensaje claro indicando que no se encontraron actividades.
- Si el tipo de actividad no tiene ruta de edición disponible, el sistema informa que no se puede abrir todavía.

## CU-09: Gestionar notificaciones

| Campo | Descripción |
|---|---|
| Actor | Usuario / Sistema |
| Descripción | Gestiona programación, reprogramación y cancelación de notificaciones locales. |
| Precondiciones | Existen actividades con aviso o configuración de notificaciones. |
| Postcondiciones | Las notificaciones quedan alineadas con los datos locales cuando el sistema operativo lo permite. |

**Flujo principal**

1. El sistema verifica permisos de notificación.
2. El usuario activa permisos si es necesario.
3. El sistema programa avisos para actividades correspondientes.
4. Si una actividad cambia, el sistema actualiza sus avisos.
5. Si una actividad se completa o elimina, el sistema cancela avisos innecesarios.

**Flujos alternativos**

- Si el sistema operativo limita alarmas o segundo plano, la app informa la limitación.
- Si el dispositivo reinicia, la app debe reconstruir notificaciones cuando sea posible.
- Si una notificación persistente no puede mantenerse por restricciones de Android, la app no debe presentarla como imborrable.

## CU-10: Agregar enlace inteligente

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite asociar enlaces a una actividad y detecta plataformas conocidas. |
| Precondiciones | Existe una actividad o se está creando una nueva en versión intermedia. |
| Postcondiciones | El enlace queda guardado y visible con acceso directo cuando aplique. |

**Flujo principal**

1. El usuario agrega un enlace a la actividad.
2. El sistema valida el formato básico del enlace.
3. El sistema intenta detectar la plataforma.
4. El sistema guarda el enlace.
5. El sistema muestra botón de acceso y enlace completo.

**Flujos alternativos**

- Si la plataforma no se detecta, el enlace se guarda como genérico.
- Si el enlace no se puede abrir, el usuario puede copiarlo manualmente.

## CU-11: Registrar actividad por voz o texto

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite ingresar una frase escrita o hablada para detectar una posible actividad. |
| Precondiciones | La función está disponible en una versión avanzada. |
| Postcondiciones | La actividad se guarda solo después de confirmación del usuario. |

**Flujo principal**

1. El usuario presiona el botón de entrada por texto o voz.
2. Elige escribir o hablar.
3. El sistema obtiene texto escrito o transcrito.
4. El sistema aplica reglas locales e interpretación local.
5. El sistema muestra una vista previa.
6. El usuario corrige lo necesario.
7. El usuario confirma.
8. El sistema guarda la actividad.
9. El sistema guarda correcciones como ejemplo de aprendizaje local si existieron.

**Flujos alternativos**

- Si la voz no se transcribe correctamente, el usuario puede corregir el texto.
- Si no se detecta el tipo, el usuario debe seleccionarlo antes de guardar.
- Si el usuario cancela, no se guarda nada.

## CU-12: Sincronizar datos

| Campo | Descripción |
|---|---|
| Actor | Sistema |
| Descripción | Sincroniza datos locales con una base en la nube en una versión avanzada. |
| Precondiciones | La sincronización está implementada, hay conexión y existe una cuenta o identificador válido. |
| Postcondiciones | Los cambios locales y remotos quedan conciliados según reglas definidas. |

**Flujo principal**

1. El sistema detecta conexión disponible.
2. Consulta cambios locales pendientes.
3. Envía cambios a la nube.
4. Descarga cambios remotos.
5. Resuelve conflictos según reglas definidas.
6. Actualiza estados de sincronización locales.

**Flujos alternativos**

- Si no hay conexión, los cambios quedan pendientes localmente.
- Si hay conflicto, el sistema conserva información suficiente para resolverlo sin perder datos.
- Si falla la sincronización, la app sigue funcionando offline.

## CU-13: Gestionar categorías

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite crear, editar y asignar categorías con color en versión intermedia. |
| Precondiciones | La gestión de categorías está disponible. |
| Postcondiciones | Las categorías quedan guardadas localmente y pueden asignarse a actividades. |

**Flujo principal**

1. El usuario abre gestión de categorías.
2. Crea una categoría con nombre.
3. Asigna un color.
4. El sistema valida los datos.
5. El sistema guarda la categoría.
6. El usuario puede asignarla a una actividad.

**Flujos alternativos**

- Si falta el nombre, el sistema solicita completarlo.
- Si el color tiene poco contraste, la interfaz debe mantener legibilidad.

## CU-14: Saltar repetición

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite omitir una ocurrencia específica sin eliminar la actividad recurrente. |
| Precondiciones | Existe una rutina o tarea recurrente con ocurrencia pendiente. |
| Postcondiciones | La ocurrencia queda marcada como saltada y la actividad principal sigue activa. |

**Flujo principal**

1. El usuario selecciona una ocurrencia.
2. Elige saltar repetición.
3. El sistema solicita confirmación si corresponde.
4. El sistema actualiza `OcurrenciaActividad.estadoOcurrencia` a saltada.
5. El sistema registra la acción en historial.

**Flujos alternativos**

- Si el usuario cancela, la ocurrencia permanece pendiente.
- Si la ocurrencia ya está completada, el sistema impide saltarla o solicita deshacer primero.

## CU-15: Detectar conflicto de horario

| Campo | Descripción |
|---|---|
| Actor | Usuario / Sistema |
| Descripción | Advierte cuando una actividad con horario se cruza con otra ya registrada. |
| Precondiciones | La detección de conflictos está disponible en versión avanzada. |
| Postcondiciones | El usuario recibe una advertencia antes de guardar o reprogramar. |

**Flujo principal**

1. El usuario crea o edita una actividad con fecha y horario.
2. El sistema consulta actividades y ocurrencias del mismo rango.
3. El sistema detecta si existe cruce.
4. El sistema muestra advertencia.
5. El usuario corrige el horario o decide continuar si el flujo lo permite.

**Flujos alternativos**

- Si no hay cruce, la actividad se guarda sin advertencia.
- Si la actividad no tiene horario, no se ejecuta detección de conflicto.

## CU-16: Configurar valores predeterminados

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite definir valores por defecto para nuevas actividades. |
| Precondiciones | El módulo de configuración está disponible. |
| Postcondiciones | Las nuevas actividades usan los valores configurados cuando aplique. |

**Flujo principal**

1. El usuario abre configuración.
2. Selecciona el valor predeterminado que desea cambiar.
3. Ingresa o selecciona el nuevo valor.
4. El sistema valida y guarda la configuración.
5. El sistema aplica el valor en nuevos formularios.

**Flujos alternativos**

- Si el usuario borra el valor, el sistema vuelve al comportamiento normal.
- Si el valor es inválido, el sistema solicita corregirlo.

## CU-17: Agregar ubicación y abrir en mapas

| Campo | Descripción |
|---|---|
| Actor | Usuario |
| Descripción | Permite agregar una ubicación manual a una actividad y abrirla en mapas. |
| Precondiciones | La función de ubicación manual está disponible en versión intermedia. |
| Postcondiciones | La ubicación queda guardada como texto y puede abrirse con una aplicación compatible. |

**Flujo principal**

1. El usuario crea o edita una actividad.
2. Ingresa una ubicación manual.
3. El sistema guarda la ubicación.
4. El usuario selecciona abrir en mapas.
5. El sistema intenta abrir una aplicación de mapas usando el texto ingresado.

**Flujos alternativos**

- Si no hay ubicación, no se muestra acción de mapas.
- Si no hay aplicación compatible, el sistema mantiene visible la ubicación para copiarla.
- La función no debe usar recordatorios por ubicación ni geocercas.

## CU-18: Solicitar permisos de notificación

| Campo | Descripción |
|---|---|
| Actor | Usuario / Sistema |
| Descripción | Solicita y orienta sobre permisos necesarios para notificaciones, alarmas y segundo plano. |
| Precondiciones | El usuario crea una actividad con aviso o entra a configuración de notificaciones. |
| Postcondiciones | El usuario conoce el estado de permisos y las limitaciones aplicables. |

**Flujo principal**

1. El sistema detecta que falta un permiso necesario.
2. Muestra una explicación breve.
3. Solicita el permiso o guía al usuario a configuración.
4. Guarda la actividad aunque el permiso no se conceda.
5. Informa que la notificación puede no funcionar hasta activar permisos.

**Flujos alternativos**

- Si Android exige permiso de alarma exacta, el sistema lo explica sin prometer exactitud total.
- Si el usuario rechaza permisos, la app mantiene el funcionamiento local sin bloquear el registro.
