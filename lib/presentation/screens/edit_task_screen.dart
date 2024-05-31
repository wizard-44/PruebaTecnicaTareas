import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/controllers/tarea_controller.dart';
import 'package:prueba_tecnica/models/tarea.dart';
import 'package:prueba_tecnica/presentation/screens/dashboard_screen.dart';
import 'package:prueba_tecnica/presentation/widgets/custom_task_date_picker.dart';
import 'package:prueba_tecnica/presentation/widgets/custom_task_field.dart';
import 'package:prueba_tecnica/utils/date_utils.dart' as custom_date_utils;

class EditTaskScreen extends StatefulWidget {
  final String id;

  const EditTaskScreen({super.key, required this.id});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TareaController _tareaController = TareaController();

  final TextEditingController dateController = TextEditingController();
  String? description;
  DateTime? selectedDate;
  bool? isCompleted;
  late Future<Tarea> _detalleTarea;

  @override
  void initState() {
    super.initState();
    _detalleTarea = _tareaController.obtenerDetalleTarea(widget.id);
    _detalleTarea.then((tarea) {
      setState(() {
        description = tarea.descripcion;
        selectedDate = tarea.fechaVencimiento.toDate();
        isCompleted = tarea.completada;
        dateController.text = custom_date_utils.DateUtils.formatTimestamp(tarea.fechaVencimiento);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
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
            return _buildForm();
          } else {
            return const Center(child: Text('No se encontraron detalles de la tarea'));
          }
        },
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _descriptionTask(),
                  const SizedBox(height: 20),
                  _dateExpirationTask(),
                  const SizedBox(height: 20),
                  _stateTask(),
                  const SizedBox(height: 20),
                  _buttonUpdateTask(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionTask() {
    return CustomTaskField(
      isTopField: true,
      label: 'Descripción',
      initialValue: description ?? '',
      onSaved: (value) => description = value,
      validator: (value) => value!.isEmpty ? 'Por favor ingrese la descripción' : null,
    );
  }

  Widget _dateExpirationTask() {
    return DatePickerFormField(
      controller: dateController,
      label: 'Fecha de Vencimiento',
      onDateSelected: (DateTime date) {
        setState(() {
          selectedDate = date;
        });
      },
    );
  }

  Widget _stateTask() {
    final textStyles = Theme.of(context).textTheme;
    return DropdownButtonFormField<bool>(
      value: isCompleted,
      onChanged: (newValue) {
        setState(() {
          isCompleted = newValue ?? false;
        });
      },
      items: [
        DropdownMenuItem<bool>(
          value: true,
          child: Text("Completado", style: textStyles.labelLarge),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text("No completado", style: textStyles.labelLarge),
        ),
      ],
      decoration: const InputDecoration(
        labelText: 'Estado',
        prefixIcon: Icon(Icons.check_circle_outline),
      ),
    );
  }

  Widget _buttonUpdateTask() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ),
        onPressed: _actualizar,
        child: const Text('ACTUALIZAR'),
      ),
    );
  }

  Future<void> _actualizar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DateTime fechaSeleccionada = selectedDate ?? DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(fechaSeleccionada);

      try {
        await _tareaController.actualizarTarea(
          widget.id,
          description ?? '-',
          timestamp,
          isCompleted ?? false,
        );
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarea Actualizada Correctamente'),
              backgroundColor: Color(0xFF28A745),
            ),
          );
        }
      } catch (error) {
        _mostrarError('Ocurrió un error: $error');
      }
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: const Color(0xFFdc3545),
      ),
    );
  }
}
