import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activities/presentation/screens/tarea_form_screen.dart';
import '../../features/activities/presentation/screens/tareas_list_screen.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Ruta no encontrada: ${state.uri}'),
      ),
    ),
  );
}
