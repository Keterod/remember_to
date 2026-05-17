# Requisitos no funcionales

Los requisitos no funcionales definen cómo debe comportarse Remember To.App más allá de sus funciones visibles.

## Usabilidad

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-01 | Registro rápido | Crear una actividad debe requerir pocos pasos y mostrar solo los campos necesarios según el tipo. | Alta |
| RNF-02 | Diferenciación clara | La interfaz debe distinguir visualmente tareas, recordatorios, eventos, rutinas y tareas mensuales. | Alta |
| RNF-03 | Confirmación explícita | Las acciones destructivas o ambiguas deben solicitar confirmación. | Alta |
| RNF-04 | Lenguaje simple | Los textos deben ser directos, sin lenguaje técnico innecesario para el usuario final. | Media |

## Rendimiento

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-05 | Respuesta local rápida | Las operaciones locales comunes deben sentirse inmediatas en dispositivos Android de gama media. | Alta |
| RNF-06 | Consultas eficientes | Las vistas Hoy, Próximas, Vencidas, Calendario y Agenda deben usar índices y filtros eficientes en base local. | Alta |
| RNF-07 | Arranque razonable | La aplicación debe iniciar sin cargar historiales completos innecesarios. | Media |

## Disponibilidad offline

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-08 | Offline-first | Crear, editar, eliminar, consultar y completar actividades debe funcionar sin internet. | Alta |
| RNF-09 | Sin bloqueo por nube | La falta de sincronización no debe impedir el uso principal de la aplicación. | Alta |

## Compatibilidad

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-10 | Android primero | La primera versión debe priorizar Android. | Alta |
| RNF-11 | Escalabilidad multiplataforma | La arquitectura debe permitir escalar a escritorio sin rehacer el dominio completo. | Media |
| RNF-12 | Dependencias mantenibles | Se deben preferir paquetes Flutter con mantenimiento activo y buena documentación. | Media |

## Mantenibilidad

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-13 | Separación por capas | El proyecto debe separar UI, estado, dominio, datos, servicios y base local. | Alta |
| RNF-14 | Reglas de negocio testeables | Las reglas de vencimiento, repetición, urgencia e interpretación deben poder probarse sin interfaz gráfica. | Alta |
| RNF-15 | Migraciones controladas | Los cambios de base de datos deben manejarse con migraciones versionadas. | Alta |

## Seguridad básica

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-16 | Datos locales protegidos por el sistema | La aplicación debe usar almacenamiento local privado de la app cuando sea posible. | Media |
| RNF-17 | Sin datos sensibles innecesarios | No se deben pedir datos personales que no sean necesarios para el uso inicial. | Alta |
| RNF-18 | Sin servicios pagados de IA | No se deben enviar audio, texto o actividades a servicios pagados de IA. | Alta |

## Escalabilidad

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-19 | Preparación para sincronización | Las entidades deben incluir identificadores estables y fechas de actualización para sincronización futura. | Media |
| RNF-20 | Crecimiento del historial | El historial debe consultarse de forma paginada o filtrada cuando crezca. | Media |
| RNF-21 | Tipos extensibles | El modelo debe permitir evolucionar los tipos de actividad sin duplicar toda la lógica. | Media |

## Persistencia local

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-22 | Base local confiable | La información principal debe guardarse en SQLite o equivalente local robusto. | Alta |
| RNF-23 | Integridad referencial | Las relaciones entre actividad, ocurrencias, categoría, repetición, notificaciones e historial deben mantenerse consistentes. | Alta |
| RNF-24 | Respaldo futuro | El modelo debe facilitar exportación e importación como copia de seguridad. | Media |

## Notificaciones confiables

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-25 | Permisos claros | El sistema debe solicitar permisos de notificación y orientar al usuario si están desactivados. | Alta |
| RNF-26 | Programación persistente | Las notificaciones programadas deben reconstruirse si el dispositivo reinicia o si la app actualiza datos, siempre que el sistema operativo lo permita. | Alta |
| RNF-27 | Limitaciones de Android | La app debe reconocer que Android puede limitar alarmas exactas, ejecución en segundo plano y notificaciones persistentes. | Alta |
| RNF-28 | Sin promesas absolutas | La aplicación no debe prometer que una notificación será imborrable o 100% exacta en todos los dispositivos. | Alta |

## Accesibilidad básica

| Código | Requisito | Descripción | Prioridad |
|---|---|---|---|
| RNF-29 | Contraste suficiente | Colores de categorías y estados deben mantener legibilidad. | Media |
| RNF-30 | Textos escalables | La UI futura debe respetar tamaños de texto del sistema cuando sea posible. | Media |
| RNF-31 | Acciones reconocibles | Botones principales deben tener nombres claros para lectores de pantalla. | Media |
