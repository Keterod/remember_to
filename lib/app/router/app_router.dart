import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/activities/presentation/screens/actividad_reciente_screen.dart';
import '../../features/activities/presentation/screens/agenda_screen.dart';
import '../../features/activities/presentation/screens/busqueda_screen.dart';
import '../../features/activities/presentation/screens/calendario_screen.dart';
import '../../features/activities/presentation/screens/evento_form_screen.dart';
import '../../features/activities/presentation/screens/eventos_list_screen.dart';
import '../../features/activities/presentation/screens/hoy_screen.dart';
import '../../features/activities/presentation/screens/proximas_screen.dart';
import '../../features/activities/presentation/screens/recordatorio_form_screen.dart';
import '../../features/activities/presentation/screens/recordatorios_list_screen.dart';
import '../../features/activities/presentation/screens/rutina_form_screen.dart';
import '../../features/activities/presentation/screens/rutinas_list_screen.dart';
import '../../features/activities/presentation/screens/tarea_form_screen.dart';
import '../../features/activities/presentation/screens/tarea_mensual_form_screen.dart';
import '../../features/activities/presentation/screens/tareas_mensuales_list_screen.dart';
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
        path: '/rutinas',
        builder: (context, state) => const RutinasListScreen(),
      ),
      GoRoute(
        path: '/rutinas/nueva',
        builder: (context, state) => const RutinaFormScreen(),
      ),
      GoRoute(
        path: '/rutinas/:id/editar',
        builder: (context, state) => RutinaFormScreen(
          rutinaId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/tareas-mensuales',
        builder: (context, state) => const TareasMensualesListScreen(),
      ),
      GoRoute(
        path: '/tareas-mensuales/nueva',
        builder: (context, state) => const TareaMensualFormScreen(),
      ),
      GoRoute(
        path: '/tareas-mensuales/:id/editar',
        builder: (context, state) => TareaMensualFormScreen(
          tareaMensualId: state.pathParameters['id'],
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
      GoRoute(
        path: '/actividad-reciente',
        builder: (context, state) => const ActividadRecienteScreen(),
      ),
      GoRoute(
        path: '/busqueda',
        builder: (context, state) => const BusquedaScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Ruta no encontrada: ${state.uri}'),
      ),
    ),
  );
}
