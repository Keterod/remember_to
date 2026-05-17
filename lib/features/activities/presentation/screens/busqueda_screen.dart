import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/app_section_navigation.dart';
import '../../application/providers/busqueda_provider.dart';
import '../../domain/entities/actividad.dart';
import '../../domain/enums/tipo_actividad.dart';

/// Búsqueda básica por título y descripción (Sprint 6).
class BusquedaScreen extends ConsumerStatefulWidget {
  const BusquedaScreen({super.key});

  @override
  ConsumerState<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends ConsumerState<BusquedaScreen> {
  static const _debounceDuration = Duration(milliseconds: 300);

  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _aplicarConsulta(String valor) {
    ref.read(busquedaActividadesProvider.notifier).buscar(valor);
  }

  void _onTextoChanged(String valor) {
    _debounce?.cancel();
    if (valor.trim().isEmpty) {
      _aplicarConsulta('');
      return;
    }
    _debounce = Timer(_debounceDuration, () => _aplicarConsulta(valor));
  }

  void _buscarAhora() {
    _debounce?.cancel();
    _aplicarConsulta(_controller.text);
  }

  void _abrirActividad(Actividad actividad) {
    final ruta = actividad.tipo.rutaEdicion(actividad.id);
    if (ruta != null) {
      context.push(ruta);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se puede abrir esta actividad todavía'),
      ),
    );
  }

  String _etiquetaTipo(TipoActividad tipo) {
    switch (tipo) {
      case TipoActividad.tarea:
        return 'Tarea';
      case TipoActividad.recordatorio:
        return 'Recordatorio';
      case TipoActividad.evento:
        return 'Evento';
      case TipoActividad.rutina:
        return 'Rutina';
      case TipoActividad.tareaMensual:
        return 'Tarea mensual';
    }
  }

  @override
  Widget build(BuildContext context) {
    final consulta = ref.watch(busquedaConsultaProvider);
    final resultadosAsync = ref.watch(busquedaActividadesProvider);
    final consultaVacia = consulta.trim().isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda'),
        actions: const [
          AppSectionNavigation(seccionActual: AppSection.busqueda),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Buscar por título o descripción',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarAhora,
                ),
              ),
              onChanged: _onTextoChanged,
              onSubmitted: (_) => _buscarAhora(),
            ),
          ),
          Expanded(
            child: resultadosAsync.when(
              loading: () {
                if (consultaVacia) {
                  return const Center(
                    child: Text(
                      'Escribe un término para buscar actividades activas.',
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (actividades) {
                if (consultaVacia) {
                  return const Center(
                    child: Text(
                      'Escribe un término para buscar actividades activas.',
                    ),
                  );
                }
                if (actividades.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron actividades.'),
                  );
                }
                return ListView.separated(
                  itemCount: actividades.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final actividad = actividades[index];
                    return ListTile(
                      title: Text(actividad.titulo),
                      subtitle: Text(_etiquetaTipo(actividad.tipo)),
                      onTap: () => _abrirActividad(actividad),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
