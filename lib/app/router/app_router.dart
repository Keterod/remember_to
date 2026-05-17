import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activities/presentation/screens/recordatorio_form_screen.dart';
import '../../features/activities/presentation/screens/recordatorios_list_screen.dart';
import '../../features/activities/presentation/screens/tarea_form_screen.dart';
import '../../features/activities/presentation/screens/tareas_list_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/tareas',
    routes: [
      GoRoute(
        path: '/tareas',
        builder: (context, state) => const TareasListScreen(),
      ),
      GoRoute(
        path: '/tareas/nueva',
        builder: (context, state) => const TareaFormScreen(),
      ),
      GoRoute(
        path: '/tareas/:id/editar',
        builder: (context, state) => TareaFormScreen(
          tareaId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/recordatorios',
        builder: (context, state) => const RecordatoriosListScreen(),
      ),
      GoRoute(
        path: '/recordatorios/nuevo',
        builder: (context, state) => const RecordatorioFormScreen(),
      ),
      GoRoute(
        path: '/recordatorios/:id/editar',
        builder: (context, state) => RecordatorioFormScreen(
          recordatorioId: state.pathParameters['id'],
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Ruta no encontrada: ${state.uri}'),
      ),
    ),
  );
}
