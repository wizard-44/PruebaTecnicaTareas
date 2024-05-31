import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/controllers/tarea_controller.dart';
import 'package:prueba_tecnica/presentation/screens/dashboard_screen.dart';
import 'package:prueba_tecnica/presentation/widgets/custom_task_date_picker.dart';
import 'package:prueba_tecnica/presentation/widgets/custom_task_field.dart';

class RegisterTaskScreen extends StatefulWidget {
  const RegisterTaskScreen({super.key});

  @override
  State<RegisterTaskScreen> createState() => _RegisterTaskScreenState();
}

class _RegisterTaskScreenState extends State<RegisterTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TareaController _tareaController = TareaController();

  final TextEditingController dateController = TextEditingController();
  String? description;
  DateTime? selectedDate;
  bool? isCompleted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Tarea'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
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
                    _buttonRegisterTask(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _descriptionTask() {
    return CustomTaskField(
      isTopField: true,
      label: 'Descripción',
      initialValue: '',
      onSaved: (value) => description = value,
      validator: (value) =>
          value!.isEmpty ? 'Por favor ingrese la descripción' : null,
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

  Widget _buttonRegisterTask() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        ),
        onPressed: _registrar,
        child: const Text('REGISTRAR'),
      ),
    );
  }

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DateTime fechaSeleccionada = selectedDate ?? DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(fechaSeleccionada);

      try {
        await _tareaController.agregarTarea(
          description ?? '-',
          timestamp,
          isCompleted ?? false,
        );

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (Route<dynamic> route) => false,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea Registrada Correctamente'),
            backgroundColor: Color(0xFF28A745),
          ),
        );
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error'),
            backgroundColor: Color(0xFFdc3545),
          ),
        );
      }
    }
  }
}
