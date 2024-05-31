import 'package:flutter/material.dart';
import 'package:prueba_tecnica/controllers/tarea_controller.dart';
import 'package:prueba_tecnica/models/tarea.dart';
import 'package:prueba_tecnica/presentation/screens/dashboard_screen.dart';
import 'package:prueba_tecnica/presentation/screens/edit_task_screen.dart';
import 'package:prueba_tecnica/utils/date_utils.dart' as custom_date_utils;

class InfoTask extends StatefulWidget {
  final String id;

  const InfoTask({super.key, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _InfoTaskState createState() => _InfoTaskState();
}

class _InfoTaskState extends State<InfoTask> {
  late Future<Tarea> _detalleTarea;
  final TareaController _tareaController = TareaController();

  @override
  void initState() {
    super.initState();
    _detalleTarea = _tareaController.obtenerDetalleTarea(widget.id);
  }

  Future<void> _handleEditar(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(id: widget.id),
      ),
    ).then((_) {
      setState(() {
        _detalleTarea = _tareaController.obtenerDetalleTarea(widget.id);
      });
    });
  }

  Future<void> _handleCancelar(BuildContext context, String id) async {
    bool confirmado = await _mostrarDialogoConfirmacion(context);
    if (confirmado) {
      // ignore: use_build_context_synchronously
      await _eliminarTarea(context, id);
    }
  }

  Future<bool> _mostrarDialogoConfirmacion(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> _eliminarTarea(BuildContext context, String id) async {
    try {
      await _tareaController.eliminarTareaPorId(id);
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) => false,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La tarea ha sido eliminada.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _mostrarError(context, 'Error al eliminar la tarea: $e');
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalles de la Tarea', style: textStyles.titleSmall),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: FutureBuilder<Tarea>(
          future: _detalleTarea,
          builder: (context, snapshotTarea) {
            if (snapshotTarea.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshotTarea.hasError) {
              return const Center(child: Text('Error al cargar los detalles de la Tarea'));
            } else if (snapshotTarea.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailCard(snapshotTarea.data!),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _handleEditar(context),
                            child: const Text('Editar Tarea'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _handleCancelar(context, snapshotTarea.data!.id),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Eliminar Tarea'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No se encontraron detalles de la tarea'));
            }
          },
        ),
      ),
    );
  }

  Widget _detailCard(Tarea tarea) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _quoteDetailRow(title: 'Descripción:', value: tarea.descripcion),
            _quoteDetailRow(
              title: 'Fecha de Vencimiento:',
              value: custom_date_utils.DateUtils.formatTimestamp(tarea.fechaVencimiento),
            ),
            _quoteDetailRow(
              title: 'Fecha de Creación:',
              value: custom_date_utils.DateUtils.formatTimestamp(tarea.fechaCreacion),
            ),
            _quoteDetailRow(
              title: 'Estado:',
              value: tarea.completada ? 'Completada' : 'No completada',
            ),
          ],
        ),
      ),
    );
  }

  Widget _quoteDetailRow({required String title, required String value}) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w300
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
