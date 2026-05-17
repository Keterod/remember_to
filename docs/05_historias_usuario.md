# Historias de usuario

Las historias de usuario resumen necesidades concretas del sistema desde el punto de vista del usuario final.

## HU-01: Crear tarea

Como usuario,  
quiero crear una tarea con título, nota, fecha límite opcional y marca urgente opcional,  
para recordar una actividad puntual que debo realizar.

**Criterios de aceptación**

- Dado que estoy en el formulario de nueva actividad, cuando selecciono el tipo tarea y guardo un título válido, entonces la tarea queda registrada.
- Dado que una tarea no tiene fecha límite, cuando se guarda, entonces no debe aparecer como vencida.
- Dado que marco la tarea como urgente, cuando la consulto, entonces se muestra con la marca urgente.

## HU-02: Crear recordatorio

Como usuario,  
quiero crear un recordatorio con fecha y hora de aviso,  
para recibir una notificación en el momento indicado.

**Criterios de aceptación**

- Dado que ingreso título, fecha y hora, cuando guardo el recordatorio, entonces se programa la notificación local básica.
- Dado que falta fecha u hora de aviso, cuando intento guardar, entonces el sistema solicita completar el dato requerido.
- Dado que llega la fecha y hora configurada, cuando las notificaciones están permitidas por el sistema operativo, entonces el sistema muestra el aviso.

## HU-03: Crear evento

Como usuario,  
quiero crear un evento con fecha, hora de inicio y hora de fin,  
para organizar actividades que ocurren en un bloque de tiempo.

**Criterios de aceptación**

- Dado que ingreso fecha, hora de inicio y hora de fin válidas, cuando guardo, entonces el evento aparece en calendario y agenda.
- Dado que la hora de fin es anterior a la hora de inicio, cuando intento guardar, entonces el sistema solicita corregir el horario.
- Dado que el evento se guarda, cuando lo consulto, entonces muestra su intervalo de inicio y fin.

## HU-04: Crear rutina

Como usuario,  
quiero crear una rutina con días o frecuencia,  
para mantener constancia en actividades repetitivas.

**Criterios de aceptación**

- Dado que selecciono días o frecuencia, cuando guardo la rutina, entonces se registra su regla de repetición.
- Dado que una rutina corresponde al día actual, cuando consulto Hoy, entonces la rutina aparece mediante una ocurrencia del día.
- Dado que marco la rutina como realizada, cuando vuelvo a verla el mismo día, entonces solo la ocurrencia de ese día aparece como completada.

## HU-05: Crear tarea mensual

Como usuario,  
quiero crear una tarea mensual con día específico del mes,  
para recordar obligaciones que se repiten cada mes.

**Criterios de aceptación**

- Dado que selecciono un día del mes, cuando guardo la tarea mensual, entonces queda programada para repetirse mensualmente.
- Dado que marco la tarea mensual como completada en el mes actual, cuando llega el siguiente mes, entonces la repetición sigue activa.
- Dado que el mes no tiene el día configurado, cuando se calcula la ocurrencia, entonces el sistema la programa para el último día disponible del mes.
- Dado que una tarea mensual está configurada para el día 31, cuando el mes es febrero, entonces se programa para el 28 o 29 de febrero según corresponda.

## HU-06: Marcar actividad completada

Como usuario,  
quiero marcar una actividad como completada,  
para llevar control de lo que ya hice.

**Criterios de aceptación**

- Dado que una actividad está pendiente, cuando la marco como completada, entonces cambia su estado base a completada.
- Dado que una rutina o tarea mensual tiene una ocurrencia pendiente, cuando marco esa ocurrencia como completada, entonces no se completa toda la actividad recurrente.
- Dado que una actividad u ocurrencia se completó, cuando consulto historial, entonces aparece el evento de cumplimiento.

## HU-07: Ver sección Hoy

Como usuario,  
quiero ver una sección Hoy,  
para revisar rápidamente todo lo programado para el día actual.

**Criterios de aceptación**

- Dado que existen actividades para hoy, cuando abro la sección Hoy, entonces se muestran agrupadas u ordenadas de forma clara.
- Dado que una actividad no tiene fecha, cuando abro Hoy, entonces no aparece como actividad programada del día.
- Dado que una actividad u ocurrencia está completada, cuando abro Hoy, entonces su estado se muestra correctamente.

## HU-08: Ver próximas actividades

Como usuario,  
quiero ver actividades futuras ordenadas por fecha y hora,  
para anticiparme a lo que viene.

**Criterios de aceptación**

- Dado que existen actividades futuras, cuando abro Próximas, entonces se ordenan cronológicamente.
- Dado que una actividad futura es urgente, cuando aparece en la lista, entonces conserva su marca urgente.
- Dado que no existen actividades futuras, cuando abro la vista, entonces se muestra un estado vacío claro.

## HU-09: Ver actividades vencidas

Como usuario,  
quiero ver actividades vencidas,  
para identificar lo que no completé a tiempo.

**Criterios de aceptación**

- Dado que una actividad u ocurrencia pendiente tiene fecha u hora pasada, cuando consulto Vencidas, entonces aparece como vencida calculada.
- Dado que una actividad no tiene fecha límite, cuando consulto Vencidas, entonces no aparece.
- Dado que completo o reprogramo una actividad vencida, cuando actualizo la vista, entonces deja de mostrarse como vencida.

## HU-10: Usar calendario

Como usuario,  
quiero visualizar mis actividades en calendario diario, semanal o mensual,  
para entender mi distribución de tiempo.

**Criterios de aceptación**

- Dado que existen eventos y actividades programadas, cuando abro calendario, entonces se muestran en la fecha correspondiente.
- Dado que cambio entre vista diaria, semanal o mensual, cuando la vista se actualiza, entonces se mantiene la información coherente.
- Dado que selecciono una fecha, cuando la abro, entonces veo sus actividades y ocurrencias.

## HU-11: Usar agenda

Como usuario,  
quiero ver una agenda organizada por día y hora,  
para revisar mis actividades en orden temporal.

**Criterios de aceptación**

- Dado que existen actividades con fecha y hora, cuando abro Agenda, entonces se muestran ordenadas por día y hora.
- Dado que una actividad no tiene hora exacta, cuando aparece en Agenda, entonces se ubica en una sección adecuada sin romper el orden.
- Dado que una actividad tiene intervalo de inicio y fin, cuando la consulto, entonces se muestra su duración o bloque horario.

## HU-12: Agregar enlace inteligente

Como usuario,  
quiero agregar enlaces a una actividad,  
para abrir rápidamente recursos como reuniones, documentos o videos.

**Criterios de aceptación**

- Dado que agrego un enlace de Meet, Zoom, Drive, Docs o YouTube, cuando guardo, entonces el sistema identifica la plataforma si es posible.
- Dado que el sistema detecta la plataforma, cuando veo la actividad, entonces muestra un botón de acceso directo.
- Dado que el botón falla o no está disponible, cuando veo el enlace, entonces también puedo copiar el enlace completo.

## HU-13: Posponer desde notificación

Como usuario,  
quiero posponer una actividad desde la notificación,  
para aplazarla sin abrir todo el formulario.

**Criterios de aceptación**

- Dado que recibo una notificación con opción de posponer, cuando selecciono posponer, entonces se actualiza la próxima hora de aviso.
- Dado que la actividad tiene una ocurrencia concreta, cuando la pospongo desde la notificación, entonces se actualiza esa ocurrencia y no toda la repetición.
- Dado que el sistema operativo no permite la acción, cuando recibo la notificación, entonces la app debe mantener una alternativa dentro de la aplicación.

## HU-14: Completar desde notificación

Como usuario,  
quiero marcar una actividad como completada desde la notificación,  
para cerrar pendientes rápidamente.

**Criterios de aceptación**

- Dado que recibo una notificación con opción de completar, cuando selecciono completar, entonces la actividad u ocurrencia cambia a completada.
- Dado que la actividad se completa desde notificación, cuando abro la app, entonces el estado ya está actualizado.
- Dado que Android limita la acción de notificación, cuando no se puede completar desde el aviso, entonces la app debe permitir completar desde la actividad.

## HU-15: Registrar actividad por texto o voz

Como usuario,  
quiero escribir o hablar una frase para registrar una actividad,  
para crear registros más rápido.

**Criterios de aceptación**

- Dado que presiono el botón de registro por texto o voz, cuando ingreso una frase, entonces el sistema intenta detectar datos posibles.
- Dado que uso voz, cuando se transcribe el audio, entonces el sistema trabaja con el texto resultante.
- Dado que no se puede interpretar con seguridad, cuando se muestra la vista previa, entonces el usuario debe completar los campos faltantes.

## HU-16: Confirmar actividad antes de guardar

Como usuario,  
quiero ver una vista previa antes de guardar una actividad detectada,  
para evitar registros incorrectos.

**Criterios de aceptación**

- Dado que el sistema detecta una posible actividad, cuando termina el análisis, entonces muestra una vista previa editable.
- Dado que no confirmo la vista previa, cuando cierro el flujo, entonces no se guarda la actividad.
- Dado que confirmo la vista previa, cuando guardo, entonces se crea una actividad con tipo definido.

## HU-17: Corregir actividad detectada

Como usuario,  
quiero corregir tipo, título, fecha, hora, repetición, urgencia y categoría antes de guardar,  
para que el registro sea correcto.

**Criterios de aceptación**

- Dado que la vista previa tiene datos incompletos, cuando edito los campos, entonces el sistema permite corregirlos.
- Dado que cambio el tipo de actividad, cuando guardo, entonces se validan los campos requeridos del nuevo tipo.
- Dado que intento guardar sin un tipo definido, cuando confirmo, entonces el sistema impide guardar.

## HU-18: Guardar corrección como aprendizaje local

Como usuario,  
quiero que mis correcciones se guarden localmente,  
para que la aplicación mejore futuras detecciones sin usar IA pagada.

**Criterios de aceptación**

- Dado que corrijo una actividad detectada, cuando confirmo el guardado, entonces se almacena un ejemplo local.
- Dado que se guarda el ejemplo, cuando no hay internet, entonces el guardado funciona igual.
- Dado que consulto la configuración futura de aprendizaje local, cuando existe información, entonces debe poder gestionarse sin enviarla a servicios pagados.

## HU-19: Trabajar sin conexión

Como usuario,  
quiero usar la aplicación sin internet,  
para registrar y consultar mis actividades en cualquier momento.

**Criterios de aceptación**

- Dado que no tengo conexión, cuando creo, edito, consulto o completo una actividad, entonces la operación funciona localmente.
- Dado que la sincronización futura no está disponible, cuando uso la app, entonces no se bloquea el flujo principal.
- Dado que recupero conexión en una versión con nube, cuando hay cambios pendientes, entonces se sincronizan según las reglas definidas.

## HU-20: Crear categoría

Como usuario,  
quiero crear categorías personalizadas,  
para organizar mis actividades por áreas como estudio, trabajo, salud o pagos.

**Criterios de aceptación**

- Dado que estoy en configuración o gestión de categorías, cuando ingreso un nombre válido, entonces la categoría se guarda.
- Dado que intento crear una categoría sin nombre, cuando guardo, entonces el sistema solicita completar el nombre.
- Dado que la categoría existe, cuando creo o edito una actividad, entonces puedo seleccionarla.

## HU-21: Asignar color a categoría

Como usuario,  
quiero asignar un color a una categoría,  
para diferenciar visualmente mis actividades.

**Criterios de aceptación**

- Dado que una categoría existe, cuando selecciono un color, entonces el color queda asociado a la categoría.
- Dado que una actividad tiene categoría con color, cuando la consulto, entonces se muestra una referencia visual clara.
- Dado que el color elegido tiene poco contraste, cuando se muestra en la interfaz, entonces el sistema debe mantener la legibilidad.

## HU-22: Definir duración estimada

Como usuario,  
quiero definir una duración estimada para una actividad,  
para organizar mejor mi agenda.

**Criterios de aceptación**

- Dado que creo o edito una actividad compatible, cuando ingreso una duración válida, entonces se guarda en minutos.
- Dado que la duración está registrada, cuando veo la agenda, entonces puede usarse para mostrar el bloque horario o estimación.
- Dado que ingreso una duración inválida, cuando guardo, entonces el sistema solicita corregirla.

## HU-23: Detectar conflicto de horario

Como usuario,  
quiero que el sistema me avise cuando una actividad se cruza con otra,  
para evitar programar dos compromisos al mismo tiempo.

**Criterios de aceptación**

- Dado que creo una actividad con horario, cuando se cruza con otra ya registrada, entonces el sistema muestra una advertencia.
- Dado que aparece una advertencia de conflicto, cuando decido continuar, entonces el sistema puede guardar la actividad si el flujo lo permite.
- Dado que no hay cruce de horario, cuando guardo, entonces no se muestra advertencia.

## HU-24: Saltar una repetición

Como usuario,  
quiero saltar una repetición específica de una rutina o tarea recurrente,  
para omitir solo esa fecha sin eliminar toda la actividad.

**Criterios de aceptación**

- Dado que existe una ocurrencia pendiente, cuando elijo saltarla, entonces `OcurrenciaActividad` queda con estado saltada.
- Dado que una ocurrencia fue saltada, cuando consulto próximas fechas, entonces la actividad recurrente sigue activa.
- Dado que consulto historial, cuando una ocurrencia fue saltada, entonces aparece la acción correspondiente.

## HU-25: Configurar valores predeterminados

Como usuario,  
quiero definir valores predeterminados para nuevas actividades,  
para registrar información repetida con menos pasos.

**Criterios de aceptación**

- Dado que configuro un valor predeterminado, cuando creo una actividad nueva, entonces el campo correspondiente se completa automáticamente.
- Dado que cambio un valor predeterminado, cuando creo otra actividad, entonces se usa el nuevo valor.
- Dado que elimino un valor predeterminado, cuando creo una actividad, entonces el campo vuelve a su comportamiento normal.

## HU-26: Agregar ubicación opcional

Como usuario,  
quiero agregar una ubicación manual a una actividad,  
para recordar dónde debo realizarla.

**Criterios de aceptación**

- Dado que creo o edito una actividad, cuando escribo una ubicación, entonces queda guardada como texto.
- Dado que no ingreso ubicación, cuando guardo, entonces la actividad se guarda sin ubicación.
- Dado que la ubicación fue ingresada manualmente, cuando veo la actividad, entonces se muestra sin requerir permisos de ubicación.

## HU-27: Abrir ubicación en mapas

Como usuario,  
quiero abrir la ubicación registrada en una aplicación de mapas,  
para llegar más fácilmente al lugar.

**Criterios de aceptación**

- Dado que una actividad tiene ubicación manual, cuando selecciono abrir en mapas, entonces el sistema intenta abrir una app compatible.
- Dado que no hay aplicación de mapas disponible, cuando intento abrir la ubicación, entonces el sistema mantiene el texto visible para copiarlo.
- Dado que la actividad no tiene ubicación, cuando la consulto, entonces no se muestra una acción de abrir en mapas.

## HU-28: Solicitar permisos de notificación

Como usuario,  
quiero que la aplicación me solicite y explique los permisos de notificación necesarios,  
para recibir avisos de mis actividades.

**Criterios de aceptación**

- Dado que las notificaciones no tienen permiso, cuando creo una actividad con aviso, entonces el sistema solicita u orienta para activar permisos.
- Dado que Android exige permisos adicionales para alarmas exactas o segundo plano, cuando sean necesarios, entonces el sistema informa la limitación de forma clara.
- Dado que el usuario no concede permisos, cuando la actividad se guarda, entonces la app no debe prometer una notificación garantizada.
