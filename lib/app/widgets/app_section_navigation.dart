import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navegación mínima entre secciones del MVP (Sprint 4).
class AppSectionNavigation extends StatelessWidget {
  const AppSectionNavigation({
    super.key,
    required this.seccionActual,
  });

  final AppSection seccionActual;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppSection>(
      tooltip: 'Ir a otra sección',
      icon: const Icon(Icons.menu),
      onSelected: (seccion) {
        if (seccion == seccionActual) {
          return;
        }
        context.go(seccion.ruta);
      },
      itemBuilder: (context) {
        return AppSection.values
            .map(
              (seccion) => PopupMenuItem(
                value: seccion,
                enabled: seccion != seccionActual,
                child: Text(seccion.etiqueta),
              ),
            )
            .toList();
      },
    );
  }
}

enum AppSection {
  tareas('Tareas', '/tareas'),
  recordatorios('Recordatorios', '/recordatorios'),
  eventos('Eventos', '/eventos'),
  hoy('Hoy', '/hoy'),
  proximas('Próximas', '/proximas'),
  vencidas('Vencidas', '/vencidas'),
  calendario('Calendario', '/calendario'),
  agenda('Agenda', '/agenda');

  const AppSection(this.etiqueta, this.ruta);

  final String etiqueta;
  final String ruta;
}
