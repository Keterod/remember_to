# Análisis práctico de apps similares

Este documento no es un estado del arte académico. Es una referencia ligera para identificar ideas útiles y limitaciones frente al enfoque de Remember To.App.

## Resumen comparativo

| App | Qué aporta | Limitación frente a Remember To.App | Idea que puede inspirar |
|---|---|---|---|
| Google Calendar | Excelente vista de calendario, eventos, recordatorios básicos e integración con cuentas Google. | Está centrado en calendario; no diferencia con suficiente claridad rutinas, tareas mensuales y tareas personales simples dentro del mismo modelo. | Vista de calendario clara, eventos con enlaces de reunión y ubicación cuando el usuario la agrega. |
| Todoist | Muy bueno para tareas, organización por proyectos, fechas naturales y productividad personal. | Su enfoque principal son tareas; eventos, rutinas y obligaciones mensuales pueden terminar como tareas con etiquetas o reglas. | Captura rápida, listas claras y detección de fechas desde texto. |
| Microsoft To Do | Simple, práctico y útil para listas diarias y tareas personales. | No está pensado como agenda completa con eventos, rutinas, tareas mensuales y notificaciones avanzadas por tipo. | Sección diaria sencilla y enfoque en lo pendiente. |
| TickTick | Combina tareas, calendario, hábitos, Pomodoro y recordatorios. | Tiene muchas funciones; puede sentirse más complejo de lo necesario para un uso personal enfocado. | Integración entre tareas, calendario y hábitos sin perder acceso rápido. |
| Notion Calendar | Buena visualización de calendario e integración con espacios de trabajo. | Depende mucho del ecosistema Notion y no está pensado como app offline-first personal de recordatorios y rutinas. | Calendario limpio y relación entre eventos y contenido externo. |
| Samsung Reminder | Integrado al ecosistema Samsung, útil para avisos simples y recordatorios del dispositivo. | Limitado a recordatorios; no cubre bien tareas, eventos, rutinas y tareas mensuales como conceptos separados. | Notificaciones prácticas y simplicidad en avisos. |

## Lecturas para Remember To.App

### Diferenciar conceptos desde el inicio

La principal oportunidad de Remember To.App es separar claramente los tipos de actividad. Otras apps suelen resolverlo con listas, etiquetas o calendarios, pero eso puede mezclar conceptos que el usuario entiende de forma distinta.

### Mantener captura rápida sin crear otro módulo

Todoist y Microsoft To Do muestran que capturar rápido es importante. En Remember To.App, esa captura debe resolverse con el flujo de texto o voz y confirmación, no con una función separada llamada actividad rápida.

### Calendario y agenda deben ser útiles, no decorativos

Google Calendar y Notion Calendar inspiran vistas limpias de tiempo. Remember To.App debe usar calendario y agenda para responder preguntas simples:

- Qué tengo hoy.
- Qué viene después.
- Qué se venció.
- Qué actividad está activa ahora.

### Notificaciones como parte del núcleo

Samsung Reminder y Google Calendar muestran que una app de recordatorios depende de avisos confiables. En Remember To.App, las notificaciones no son un extra; deben estar conectadas con estado, posponer, completar y reprogramar.

También debe considerarse que Android puede limitar alarmas exactas, ejecución en segundo plano y notificaciones persistentes.

### Evitar exceso de funciones al inicio

TickTick demuestra que una app puede crecer mucho, pero Remember To.App debe evitar empezar demasiado grande. Estadísticas, checklist, pausa de rutinas y widgets pueden esperar.

## Conclusión práctica

Remember To.App debe tomar inspiración de estas aplicaciones sin copiar su alcance completo. La propuesta central es una app personal, offline-first, con tipos de actividad bien separados y preparada para registro inteligente local en el futuro.
