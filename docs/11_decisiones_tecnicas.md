# Decisiones técnicas iniciales

Este documento registra decisiones base para orientar el desarrollo. Puede evolucionar durante el proyecto, pero cualquier cambio importante debe quedar documentado.

| Código | Decisión | Estado | Justificación |
|---|---|---|---|
| DT-01 | Usar Flutter como framework principal. | Aceptada | Permite iniciar en móvil y escalar a escritorio con una base común. |
| DT-02 | Usar Dart como lenguaje. | Aceptada | Es el lenguaje natural del ecosistema Flutter. |
| DT-03 | Priorizar Android en la primera versión. | Aceptada | Es la plataforma inicial de uso personal real. |
| DT-04 | Preparar escalabilidad futura a escritorio. | Aceptada | La arquitectura debe separar dominio, datos y UI para facilitar expansión. |
| DT-05 | Usar base local primero. | Aceptada | La aplicación debe ser útil sin internet desde el inicio. |
| DT-06 | Adoptar enfoque offline-first. | Aceptada | Crear, editar y consultar actividades no debe depender de conexión. |
| DT-07 | Recomendar SQLite con Drift. | Aceptada | Drift ofrece consultas tipadas, migraciones y buena integración con Flutter. |
| DT-08 | Usar una entidad general Actividad con campo tipo. | Aceptada | Reduce duplicación y facilita vistas mixtas como Hoy, Agenda y Calendario. |
| DT-09 | No usar IA de paga. | Aceptada | El proyecto debe evitar costos y dependencia de servicios externos pagados. |
| DT-10 | No usar OpenAI Speech-to-Text ni Google Cloud Speech-to-Text. | Aceptada | La voz debe resolverse con opciones locales o gratuitas si se implementa. |
| DT-11 | Evaluar Vosk offline o speech_to_text para voz futura. | Propuesta | Son opciones más alineadas con el enfoque local/gratuito. |
| DT-12 | Usar reglas locales y ML local para interpretación futura. | Aceptada | Permite mejorar sin depender de IA en la nube. |
| DT-13 | Guardar correcciones como aprendizaje local. | Aceptada | Las correcciones del usuario pueden mejorar detecciones futuras. |
| DT-14 | Dejar sincronización en nube para versión futura. | Aceptada | Primero se debe consolidar la experiencia local. |
| DT-15 | Tratar notificaciones locales como módulo crítico. | Aceptada | La utilidad del sistema depende de avisos confiables, aunque Android puede limitarlos. |
| DT-16 | Evitar prioridades baja/media/alta en actividades. | Aceptada | Se usará solo una marca urgente opcional para reducir complejidad. |
| DT-17 | No guardar actividades sin clasificar. | Aceptada | Toda actividad debe tener tipo confirmado antes de guardarse. |
| DT-18 | No crear una función separada de actividad rápida. | Aceptada | El flujo futuro de texto o voz cubrirá el registro rápido sin duplicar conceptos. |
| DT-19 | Usar Riverpod como gestor de estado inicial. | Aceptada | Riverpod es suficiente para iniciar, mantiene buena separación de estado y puede escalar sin agregar complejidad innecesaria. |
| DT-20 | Usar ocurrencias para rutinas y tareas mensuales. | Aceptada | Permite completar, saltar o posponer una repetición concreta sin modificar toda la actividad recurrente. |
| DT-21 | Calcular vencimiento en lugar de guardarlo como estado principal. | Aceptada | Evita inconsistencias entre fechas, estados y vistas como Vencidas. |

## Decisiones pendientes

| Código | Decisión pendiente | Opciones iniciales | Momento sugerido |
|---|---|---|---|
| DP-01 | Librería de calendario | table_calendar o componente propio | Sprint 4 |
| DP-02 | Estrategia de exportación | JSON, CSV o ambos | Sprint 9 |
| DP-03 | Motor de voz futuro | Vosk offline o speech_to_text | Sprint 10 |
| DP-04 | Proveedor de nube futuro | Firebase, Supabase, servidor propio u otro | Versión avanzada |

Bloc queda como alternativa futura no elegida para el inicio del proyecto. No se mantiene como opción principal para evitar ambigüedad en la arquitectura inicial.

## Principios técnicos

- La app debe funcionar localmente antes de depender de servicios externos.
- Las reglas de negocio deben vivir fuera de la UI.
- La base de datos debe evolucionar con migraciones.
- Las notificaciones deben mantenerse sincronizadas con los cambios de actividades y ocurrencias.
- Las funciones futuras no deben complicar el MVP.
- El aprendizaje local no debe enviar datos a servicios pagados.
- Android puede limitar alarmas exactas, ejecución en segundo plano y notificaciones persistentes; la documentación y la app no deben prometer exactitud absoluta.
