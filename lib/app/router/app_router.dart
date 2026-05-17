import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activities/presentation/screens/agenda_screen.dart';
import '../../features/activities/presentation/screens/calendario_screen.dart';
import '../../features/activities/presentation/screens/evento_form_screen.dart';
import '../../features/activities/presentation/screens/eventos_list_screen.dart';
import '../../features/activities/presentation/screens/hoy_screen.dart';
import '../../features/activities/presentation/screens/proximas_screen.dart';
import '../../features/activities/presentation/screens/recordatorio_form_screen.dart';
import '../../features/activities/presentation/screens/recordatorios_list_screen.dart';
import '../../features/activities/presentation/screens/tarea_form_screen.dart';
import '../../features/activities/presentation/screens/tareas_list_screen.dart';
import '../../features/activities/presentation/screens/vencidas_screen.dart';

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
      GoRoute(
        path: '/eventos',
        builder: (context, state) => const EventosListScreen(),
      ),
      GoRoute(
        path: '/eventos/nuevo',
        builder: (context, state) => const EventoFormScreen(),
      ),
      GoRoute(
        path: '/eventos/:id/editar',
        builder: (context, state) => EventoFormScreen(
          eventoId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/hoy',
        builder: (context, state) => const HoyScreen(),
      ),
      GoRoute(
        path: '/proximas',
        builder: (context, state) => const ProximasScreen(),
      ),
      GoRoute(
        path: '/vencidas',
        builder: (context, state) => const VencidasScreen(),
      ),
      GoRoute(
        path: '/calendario',
        builder: (context, state) => const CalendarioScreen(),
      ),
      GoRoute(
        path: '/agenda',
        builder: (context, state) => const AgendaScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Ruta no encontrada: ${state.uri}'),
      ),
    ),
  );
}
