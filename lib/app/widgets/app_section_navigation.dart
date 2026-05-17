import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navegación mínima entre secciones del MVP (Sprint 3).
class AppSectionNavigation extends StatelessWidget {
  const AppSectionNavigation({
    super.key,
    required this.seccionActual,
  });

  final AppSection seccionActual;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: seccionActual == AppSection.tareas
              ? null
              : () => context.go('/tareas'),
          child: const Text('Tareas'),
        ),
        TextButton(
          onPressed: seccionActual == AppSection.recordatorios
              ? null
              : () => context.go('/recordatorios'),
          child: const Text('Recordatorios'),
        ),
      ],
    );
  }
}

enum AppSection { tareas, recordatorios }
