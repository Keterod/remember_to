# Backlog inicial por sprints

Propuesta de trabajo en iteraciones semanales o cortas. El orden busca construir primero una base local útil y luego agregar funciones intermedias y avanzadas.

## Sprint 0: Preparación documental y decisiones técnicas

**Objetivo**  
Dejar documentado el alcance, requisitos, arquitectura y decisiones iniciales.

**Historias o requisitos incluidos**  
RF-30, RF-31 y documentos base del proyecto.

**Tareas técnicas**

- Revisar documentación inicial.
- Confirmar arquitectura base.
- Confirmar Riverpod como gestor de estado inicial.
- Confirmar base local con SQLite/Drift.
- Definir convenciones de carpetas y nombres.

**Criterios de aceptación**

- Existe documentación inicial coherente.
- El MVP queda delimitado.
- Las funciones intermedias, avanzadas y postergadas quedan claras.

**Resultado esperado**  
Base documental lista para crear el proyecto Flutter.

## Sprint 1: Base Flutter + estructura + base local

**Objetivo**  
Crear el proyecto Flutter y preparar la estructura técnica inicial.

**Historias o requisitos incluidos**  
RF-30, RF-31.

**Tareas técnicas**

- Crear proyecto Flutter.
- Configurar estructura de carpetas.
- Agregar Drift y SQLite.
- Crear esquema inicial.
- Configurar migraciones.
- Crear repositorios base.
- Preparar modelo de `Actividad` con estados base principales del MVP: pendiente y completada.

**Criterios de aceptación**

- La app arranca en Android.
- La base local se inicializa correctamente.
- Se puede guardar y consultar una entidad simple de prueba.

**Resultado esperado**  
Base técnica lista para implementar actividades.

## Sprint 2: Tareas y actividades generales

**Objetivo**  
Implementar el núcleo de actividades y el flujo de tareas.

**Historias o requisitos incluidos**  
HU-01, HU-06, RF-03, RF-04, RF-13, RF-14, RF-15, RF-16, RF-20, RF-23, RF-26, RF-51, RF-64, RF-69.

**Tareas técnicas**

- Crear entidad `Actividad`.
- Implementar estados base principales del MVP: pendiente y completada.
- Implementar tipo tarea.
- Implementar marca urgente.
- Agregar edición y eliminación con confirmación.
- Agregar filtros por tipo.
- Registrar historial básico.
- Calcular condición vencida sin guardarla como estado permanente.

El estado cancelada queda fuera del MVP y solo debe agregarse en el futuro si se implementa una acción explícita de cancelación.

**Criterios de aceptación**

- Se pueden crear, editar, eliminar y completar tareas.
- Las tareas sin fecha no aparecen como vencidas.
- La eliminación solicita confirmación.
- Las vencidas se muestran como condición calculada.

**Resultado esperado**  
Primer flujo funcional de gestión de tareas.

## Sprint 3: Recordatorios y notificaciones básicas

**Objetivo**  
Implementar recordatorios con notificaciones locales básicas.

**Historias o requisitos incluidos**  
HU-02, HU-28, RF-05, RF-06, RF-66.

**Tareas técnicas**

- Crear tipo recordatorio.
- Validar fecha y hora obligatorias.
- Integrar `flutter_local_notifications`.
- Solicitar permisos de notificación.
- Programar, cancelar y reprogramar avisos básicos.
- Documentar limitaciones de Android sobre alarmas exactas y segundo plano.

**Criterios de aceptación**

- Un recordatorio con fecha y hora futura se guarda correctamente.
- La notificación se programa si existen permisos y soporte del sistema operativo.
- Si faltan permisos, el sistema orienta al usuario.
- La app no promete avisos imborrables ni exactitud total en todos los dispositivos.

**Resultado esperado**  
Recordatorios básicos funcionando con notificaciones locales.

## Sprint 4: Eventos, calendario y agenda

**Objetivo**  
Implementar eventos y vistas temporales principales del MVP.

**Historias o requisitos incluidos**  
HU-03, HU-07, HU-08, HU-09, HU-10, HU-11, RF-07, RF-08, RF-17, RF-18, RF-19, RF-65.

**Tareas técnicas**

- Crear tipo evento.
- Validar fecha, hora de inicio y hora de fin.
- Crear sección Hoy.
- Crear vista Próximas.
- Crear vista Vencidas calculadas.
- Crear calendario básico.
- Crear agenda básica por día y hora.

**Criterios de aceptación**

- Los eventos aparecen en calendario y agenda.
- Hoy muestra actividades del día.
- Próximas y Vencidas aplican reglas correctas.
- Vencida no se guarda como estado persistente principal.

**Resultado esperado**  
Visión temporal útil del sistema.

## Sprint 5: Rutinas y tareas mensuales

**Objetivo**  
Implementar actividades recurrentes esenciales del MVP.

**Historias o requisitos incluidos**  
HU-04, HU-05, RF-09, RF-10, RF-11, RF-12.

**Tareas técnicas**

- Crear modelo de repetición.
- Crear entidad `OcurrenciaActividad`.
- Implementar rutinas por días o frecuencia.
- Implementar tareas mensuales por día del mes.
- Marcar cumplimiento por ocurrencia.
- Aplicar regla de último día disponible para meses sin el día configurado.

**Criterios de aceptación**

- Las rutinas aparecen solo en días aplicables.
- Completar una ocurrencia no elimina la repetición.
- Las tareas mensuales vuelven a aparecer al mes siguiente.
- Una tarea mensual configurada para día 31 se programa el 28 o 29 de febrero según corresponda.

**Resultado esperado**  
Soporte inicial para actividades repetitivas.

## Sprint 6: Vencidas, próximas actividades e historial

**Objetivo**  
Fortalecer consultas, condiciones calculadas e historial.

**Historias o requisitos incluidos**  
HU-07, HU-08, HU-09, HU-29, RF-18, RF-19, RF-20, RF-24, RF-25, RF-26, RF-29.

**Tareas técnicas**

- Ajustar reglas de vencimiento calculado.
- Agregar búsqueda básica reactiva por título y descripción.
- Permitir seleccionar un resultado de búsqueda y abrir la actividad correspondiente.
- Mejorar historial de cambios.
- Registrar reprogramación como acción de historial.
- Mejorar ordenamientos.

**Criterios de aceptación**

- Las actividades vencidas se calculan correctamente.
- Las actividades sin fecha no se marcan como vencidas.
- Reprogramada no se guarda como estado permanente.
- El historial muestra cambios relevantes.
- La búsqueda básica debe permitir seleccionar un resultado y abrir la actividad correspondiente.

**Resultado esperado**  
Sistema más confiable para seguimiento diario.

## Sprint 7: Notificaciones avanzadas intermedias

**Objetivo**  
Agregar acciones y reglas intermedias de notificación.

**Historias o requisitos incluidos**  
HU-13, HU-14, RF-36, RF-55, RF-56, RF-57, RF-58.

**Tareas técnicas**

- Configurar avisos anticipados.
- Configurar notificaciones por tipo.
- Repetir notificación si no se marca una actividad.
- Implementar completar desde notificación.
- Implementar posponer desde notificación.
- Reprogramar avisos de ocurrencias concretas cuando aplique.
- Manejar limitaciones de Android.

**Criterios de aceptación**

- RF-56, RF-57 y RF-58 quedan implementados como funciones de prioridad alta en versión intermedia.
- Completar desde notificación actualiza la app si el sistema operativo permite la acción.
- Posponer desde notificación reprograma el aviso de la actividad u ocurrencia.
- Las limitaciones del sistema operativo quedan comunicadas.

**Entregables Sprint 7 (cerrado)**

- Payload JSON: `actividadId`, `ocurrenciaId` opcional, `tipo`, `slot`, `repeatAttempt`.
- Acciones Android: completar, posponer 10/30/60 min.
- Callback top-level sin `BuildContext`; `NotificationActionExecutor` abre Drift en segundo plano.
- Avisos anticipados por defecto: recordatorio −15 min, evento −30 min, tarea −1 h.
- Repeticiones: hasta 3 avisos cada 10 min tras el principal (sin acciones en repeticiones).
- Reglas por tipo; sin fecha/hora clara no se programa.
- Tests: `test/notification_sprint7_test.dart`.

**Resultado esperado**  
Notificaciones más útiles para uso real, sin prometer exactitud absoluta.

## Sprint 8: Categorías, enlaces inteligentes y configuración

**Objetivo**  
Mejorar organización visual, enlaces y configuración intermedia.

**Historias o requisitos incluidos**  
HU-12, HU-20, HU-21, HU-22, HU-24, HU-25, HU-26, HU-27, RF-21, RF-22, RF-28, RF-37, RF-52, RF-53, RF-54, RF-60, RF-62, RF-63, RF-67, RF-68.

**Tareas técnicas**

- Crear categorías personalizadas.
- Asignar colores.
- Crear configuraciones de valores predeterminados.
- Agregar duración estimada.
- Permitir saltar una ocurrencia.
- Agregar enlaces inteligentes.
- Detectar plataformas conocidas.
- Agregar ubicación manual.
- Abrir ubicaciones en mapas cuando existan.

**Criterios de aceptación**

- Las categorías pueden crearse y asignarse.
- Los enlaces detectados muestran botón y enlace completo.
- La configuración guarda valores locales.
- Saltar una repetición afecta solo una ocurrencia.
- La ubicación manual no usa recordatorios por ubicación.

La duración estimada puede apoyar una futura detección de conflictos, pero RF-61 no se implementa en esta versión intermedia.

**Resultado esperado**  
Aplicación más organizada y personalizable.

## Sprint 9: Importar/exportar y respaldo

**Objetivo**  
Agregar mecanismos de respaldo local.

**Historias o requisitos incluidos**  
RF-34, RF-59.

**Tareas técnicas**

- Definir formato de exportación.
- Exportar datos principales.
- Exportar ocurrencias modificadas.
- Importar datos validando estructura.
- Manejar errores de importación.

**Criterios de aceptación**

- El usuario puede generar una copia de respaldo.
- La app puede importar datos válidos.
- Importaciones inválidas no rompen la base local.

**Resultado esperado**  
Primer soporte de respaldo de información.

## Sprint 10: Prototipo de voz e interpretación local

**Objetivo**  
Probar el flujo avanzado de texto/voz sin usar IA de paga.

**Historias o requisitos incluidos**  
HU-15, HU-16, HU-17, HU-18, RF-43, RF-44, RF-45, RF-46, RF-47, RF-48, RF-49, RF-50.

**Tareas técnicas**

- Prototipar entrada por texto.
- Evaluar `speech_to_text` o Vosk offline.
- Crear reglas locales simples.
- Detectar fechas y horas básicas.
- Mostrar vista previa antes de guardar.
- Guardar correcciones como ejemplos locales.

**Criterios de aceptación**

- Una frase como "estudiar redes mañana" genera una vista previa.
- El usuario puede corregir antes de guardar.
- Nada se guarda sin confirmación.
- Las correcciones quedan almacenadas localmente.

**Resultado esperado**  
Prototipo inicial de registro inteligente sin servicios pagados.

## Consideraciones avanzadas fuera de estos sprints iniciales

- RF-32 y RF-33 de sincronización en nube quedan para una versión avanzada posterior.
- RF-38 de notificación persistente durante actividad activa queda como función avanzada sujeta a soporte del sistema operativo.
- RF-40, RF-41 y RF-42 de widgets quedan para versión avanzada.
- HU-23 y RF-61 de conflicto de horario pueden implementarse en una iteración avanzada cuando el calendario y la agenda estén maduros.
