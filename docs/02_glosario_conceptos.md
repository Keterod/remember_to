# Glosario de conceptos

## Actividad

Concepto general para referirse a cualquier registro del sistema. Una actividad puede ser una tarea, recordatorio, evento, rutina o tarea mensual.

El sistema no debe guardar actividades sin clasificar. Toda actividad debe tener un tipo definido antes de guardarse.

## Tarea

Actividad puntual que el usuario debe realizar. Puede tener título, descripción o nota, fecha límite opcional, estado base y marca urgente opcional.

Ejemplo: "Entregar informe de programación".

## Recordatorio

Aviso asociado a una fecha y hora específica. Su objetivo principal es notificar al usuario.

Ejemplo: "Recordarme tomar medicina a las 8:00 p.m.".

## Evento

Actividad ubicada en calendario, con fecha, hora de inicio, hora de fin y ubicación opcional en una versión intermedia.

Ejemplo: "Examen de redes el viernes de 10:00 a.m. a 12:00 p.m.".

## Rutina

Actividad repetitiva orientada a generar constancia. Se repite según días o frecuencia definidos por el usuario.

Ejemplo: "Hacer ejercicio de lunes a viernes".

Cada cumplimiento diario debe registrarse sobre una ocurrencia concreta, para no marcar toda la rutina como completada permanentemente.

## Tarea mensual

Actividad u obligación que se repite cada mes en una fecha específica.

Ejemplo: "Pagar internet cada día 30".

Si una tarea mensual está configurada para un día que no existe en un mes, el sistema debe programarla para el último día disponible de ese mes. Por ejemplo, si está configurada para el día 31 y el mes es febrero, se programará para el 28 o 29 de febrero según corresponda.

## Categoría

Clasificación simple que ayuda a organizar actividades. Puede representar áreas como estudio, trabajo, salud, pagos, hogar o personal.

Las categorías personalizadas y sus colores pertenecen a la versión intermedia, no al MVP principal.

## Urgente

Marca opcional que indica que una actividad requiere atención especial. No reemplaza un sistema de prioridades complejo.

Por defecto, una actividad no es urgente. Solo se marca como urgente si el usuario lo especifica.

## Actividad vencida

Condición calculada para una actividad pendiente cuya fecha u hora establecida ya pasó.

No debe guardarse como estado persistente principal. El sistema debe calcularla a partir de la fecha/hora y del estado base de la actividad u ocurrencia.

Las actividades sin fecha límite no deben considerarse vencidas.

## Actividad sin fecha límite

Actividad que no tiene una fecha definida para completarse. Puede aparecer en listas generales, pero no debe aparecer como vencida.

## Reprogramar

Cambiar la fecha, hora o repetición de una actividad. La reprogramación debe registrarse como una acción en el historial, no como un estado permanente.

## Posponer

Aplazar una actividad u ocurrencia por un tiempo corto o hacia una fecha cercana. Es una acción rápida, especialmente útil desde una notificación.

## Repetición

Regla que indica cada cuánto se repite una actividad. Puede ser diaria, semanal, mensual, anual o personalizada.

En rutinas y tareas mensuales, cada fecha concreta puede representarse como una ocurrencia para permitir completarla, saltarla o posponerla sin modificar toda la actividad.

## Notificación persistente

Notificación que se mantiene visible mientras una actividad está dentro de su intervalo activo, siempre que el sistema operativo lo permita.

En Android no debe asumirse que esta notificación será imborrable ni 100% exacta en todos los dispositivos.

## Enlace inteligente

Enlace asociado a una actividad que el sistema puede reconocer para mostrar un acceso directo más claro.

Ejemplos: Meet, Zoom, Drive, Docs, YouTube o mapas.

Esta función pertenece a la versión intermedia.

## Aprendizaje local

Proceso futuro en el que la aplicación guarda correcciones realizadas por el usuario para mejorar la clasificación e interpretación de actividades sin usar servicios pagados ni IA en la nube.

## Sincronización

Proceso futuro para mantener los datos locales alineados con una base de datos en la nube cuando exista conexión. La aplicación debe seguir funcionando aunque la sincronización no esté disponible.
