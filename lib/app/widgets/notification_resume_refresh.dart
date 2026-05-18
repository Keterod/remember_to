import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/activities/application/providers/agenda_provider.dart';
import '../../features/activities/application/providers/busqueda_provider.dart';
import '../../features/activities/application/providers/calendario_provider.dart';
import '../../features/activities/application/providers/historial_provider.dart';
import '../../features/activities/application/providers/hoy_provider.dart';
import '../../features/activities/application/providers/proximas_provider.dart';
import '../../features/activities/application/providers/recordatorios_provider.dart';
import '../../features/activities/application/providers/vencidas_provider.dart';

/// Refresca datos al volver a primer plano (respaldo si la acción fue en background).
class NotificationResumeRefresh extends ConsumerStatefulWidget {
  const NotificationResumeRefresh({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationResumeRefresh> createState() =>
      _NotificationResumeRefreshState();
}

class _NotificationResumeRefreshState extends ConsumerState<NotificationResumeRefresh>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(hoyProvider);
      ref.invalidate(proximasProvider);
      ref.invalidate(vencidasProvider);
      ref.invalidate(actividadesCalendarioProvider);
      ref.invalidate(agendaProvider);
      ref.invalidate(historialRecienteProvider);
      ref.invalidate(busquedaActividadesProvider);
      ref.invalidate(recordatoriosProvider);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
