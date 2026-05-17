# Funciones descartadas o postergadas

Este documento evita que el proyecto se desvíe del objetivo inicial. Las siguientes funciones no se implementarán por ahora o quedan para una versión futura.

| Función | Estado | Motivo |
|---|---|---|
| IA de paga | Descartada | El proyecto debe evitar costos y dependencia de servicios externos pagados. |
| OpenAI Speech-to-Text | Descartada | No se usarán servicios pagados de voz. |
| Google Cloud Speech-to-Text | Descartada | No se usarán servicios pagados de voz. |
| Estadísticas | Postergada | Puede ser útil después, pero ahora agregaría complejidad y no es necesaria para organizar actividades. |
| Checklist | Postergada | Convertiría tareas simples en subtareas. Por ahora se prioriza registro rápido. |
| Motivo de no cumplimiento | Postergada | Agrega fricción al marcar actividades y no es esencial para el uso inicial. |
| Etiquetas avanzadas | Postergada | Complican el registro rápido. Las categorías simples cubren la organización inicial. |
| Actividad rápida separada | Descartada | El flujo futuro de texto o voz ya cubre el registro rápido sin crear otro concepto. |
| Actividad sin clasificar | Descartada | Toda actividad debe tener tipo confirmado antes de guardarse para evitar confusión. |
| Bloqueo biométrico o PIN | Postergada | No es necesario para el MVP y puede agregarse luego si aparecen datos sensibles. |
| Recordatorios por ubicación | Postergada | Requieren permisos, consumo de batería y reglas adicionales. La ubicación será manual y opcional. |
| Pausar rutinas | Postergada | Puede ser útil, pero no es necesaria para el primer flujo de rutinas. |
| Archivado visible inicial | Postergada | El archivado puede considerarse internamente por rendimiento o sincronización, pero no como función visible inicial. |
| Estado del arte académico completo | Descartada | El proyecto no es una tesis. Solo se requiere análisis práctico para construir la app. |

## Regla de control

Una función postergada solo debe volver al backlog si cumple al menos una de estas condiciones:

- Resuelve un problema real del uso personal diario.
- No rompe la simplicidad del registro.
- No depende de servicios pagados.
- Puede integrarse sin rehacer la arquitectura.
- Tiene criterios de aceptación claros.
