# Visión y alcance

## Nombre del proyecto

**Remember To.App**

## Nombre formal

**Remember To.App: Aplicación multiplataforma para la gestión inteligente de recordatorios, tareas, rutinas y eventos personales.**

## Descripción general

Remember To.App es una aplicación inicialmente móvil, desarrollada con Flutter, orientada a organizar actividades personales de forma clara y práctica. La idea central es no tratar todo como una simple tarea, sino separar los registros según su naturaleza:

- Tareas.
- Recordatorios.
- Eventos.
- Rutinas.
- Tareas mensuales.

La aplicación debe funcionar primero de forma local y sin conexión, con datos almacenados en el dispositivo. En etapas futuras podrá escalar a escritorio, sincronización en la nube y registro mediante texto o voz con interpretación local.

## Problema que resuelve

Muchas aplicaciones mezclan tareas, eventos, hábitos, recordatorios y obligaciones mensuales dentro de una misma lista. Esto puede generar confusión al momento de registrar, consultar o completar actividades.

Remember To.App busca resolver ese problema diferenciando cada tipo de actividad, manteniendo un flujo rápido de registro y permitiendo que el usuario tenga una visión diaria, futura e histórica de lo que debe hacer.

## Objetivo general

Desarrollar una aplicación inicialmente móvil con Flutter, escalable posteriormente a escritorio, que permita organizar actividades personales mediante tareas, recordatorios, eventos, rutinas y tareas mensuales, diferenciando cada tipo para evitar confusiones.

## Objetivos específicos

- Permitir el registro local de actividades personales.
- Diferenciar claramente tareas, recordatorios, eventos, rutinas y tareas mensuales.
- Mostrar actividades del día, próximas actividades y actividades vencidas.
- Permitir marcar actividades como completadas cuando corresponda.
- Gestionar notificaciones locales básicas para recordatorios y actividades programadas.
- Mantener el funcionamiento principal sin conexión a internet.
- Preparar la estructura para categorías, enlaces inteligentes y configuración en una versión intermedia.
- Preparar la estructura para sincronización futura en la nube.
- Preparar el sistema para registro futuro por texto o voz usando herramientas locales o gratuitas.
- Guardar correcciones del usuario como base para aprendizaje local futuro, sin usar IA de paga.

## Público objetivo inicial

El público objetivo inicial es el propio usuario del proyecto: una persona que necesita organizar estudio, trabajo, pagos, salud, rutinas y eventos personales desde el celular.

El enfoque inicial no es comercial ni académico. Es una aplicación de uso personal real, con decisiones técnicas pensadas para crecer sin complicar el primer desarrollo.

## Alcance del MVP

El MVP debe enfocarse en las funciones esenciales para que la aplicación sea útil en el día a día:

- Crear, editar y eliminar actividades.
- Confirmar antes de eliminar.
- Crear tareas con título, descripción o nota, fecha límite opcional, estado base y marca urgente opcional.
- Crear recordatorios con fecha y hora de aviso.
- Crear eventos con fecha, hora de inicio y hora de fin.
- Crear rutinas con días o frecuencia.
- Crear tareas mensuales con día específico del mes.
- Marcar actividades como completadas cuando corresponda.
- Mostrar sección Hoy.
- Mostrar próximas actividades.
- Mostrar actividades vencidas como resultado calculado, no como estado fijo guardado manualmente.
- Mostrar calendario básico.
- Mostrar agenda básica.
- Guardar información en base de datos local.
- Funcionar sin conexión.
- Enviar notificaciones locales básicas.
- Permitir actividades sin fecha límite.
- Agregar notas o descripción a una actividad.
- Usar marca urgente opcional cuando el usuario la especifique.

## Alcance de versión intermedia

La versión intermedia debe ampliar la utilidad sin cambiar el enfoque principal:

- Enlaces inteligentes.
- Detección de plataformas desde enlaces.
- Botón de apertura y enlace completo visible.
- Completar actividad desde notificación.
- Posponer actividad desde notificación.
- Notificar nuevamente si una actividad no se marca como completada.
- Categorías más personalizadas con colores.
- Valores predeterminados para nuevas actividades.
- Duración estimada.
- Saltar una repetición sin eliminar toda la actividad.
- Ubicación opcional ingresada manualmente.
- Abrir ubicación en mapas.
- Importar y exportar datos como respaldo.
- Resumen diario configurable.
- Historial y actividad reciente más completos.

## Alcance avanzado

Funciones previstas para versiones avanzadas:

- Registro mediante voz.
- Transcripción local o gratuita.
- Interpretación local de intención.
- Reglas locales combinadas con machine learning local.
- Aprendizaje local a partir de correcciones del usuario.
- Sincronización en la nube.
- Sincronización automática cuando vuelva la conexión.
- Widgets de inicio.
- Notificación persistente avanzada durante actividad activa, siempre que el sistema operativo lo permita.
- Versión de escritorio.

## Fuera de alcance

No se implementará por ahora:

- IA de paga.
- OpenAI Speech-to-Text.
- Google Cloud Speech-to-Text.
- APIs pagadas de voz o interpretación.
- Estadísticas.
- Checklist.
- Motivo de no cumplimiento.
- Etiquetas avanzadas.
- Función separada llamada actividad rápida.
- Actividades sin clasificar.
- Bloqueo biométrico o PIN.
- Recordatorios por ubicación.
- Pausa de rutinas.
- Archivado visible inicial.
- Estado del arte académico completo.

## Supuestos y restricciones

- La primera plataforma objetivo será Android.
- La aplicación se desarrollará con Flutter y Dart.
- La base de datos inicial será local y offline.
- Se recomienda SQLite con Drift para persistencia local.
- El sistema debe poder funcionar sin internet para sus funciones principales.
- La sincronización en la nube será futura.
- Las notificaciones locales son una parte crítica del sistema, pero Android puede limitar alarmas exactas, ejecución en segundo plano y notificaciones persistentes.
- No se debe prometer que una notificación será imborrable o 100% exacta en todos los dispositivos.
- No se usará un sistema complejo de prioridades baja, media y alta.
- Por defecto, las actividades estarán en estado normal.
- Solo existirá una marca de urgente cuando el usuario lo especifique.
- Toda actividad detectada por texto o voz deberá confirmarse antes de guardarse.
- Las actividades sin fecha límite no deben aparecer como vencidas.
