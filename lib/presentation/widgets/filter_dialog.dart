import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_tecnica/controllers/tarea_controller.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool? _isCompleted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Tareas'),
      content: _buildDropdown(),
      actions: _buildActions(context),
    );
  }

  Widget _buildDropdown() {
    final textStyles = Theme.of(context).textTheme;
    return DropdownButtonFormField<bool>(
      value: _isCompleted,
      onChanged: (bool? newValue) => setState(() => _isCompleted = newValue),
      items: <DropdownMenuItem<bool>>[
        DropdownMenuItem<bool>(
            value: null, child: Text("Todas", style: textStyles.labelLarge)),
        DropdownMenuItem<bool>(
            value: true,
            child: Text("Completadas", style: textStyles.labelLarge)),
        DropdownMenuItem<bool>(
            value: false,
            child: Text("No completadas", style: textStyles.labelLarge)),
      ],
      decoration: const InputDecoration(
        labelText: 'Estado',
        prefixIcon: Icon(Icons.check_circle_outline),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      TextButton(
        onPressed: () => _applyFilter(context),
        child: const Text('Aplicar'),
      ),
    ];
  }

  void _applyFilter(BuildContext context) {
    Provider.of<TareaController>(context, listen: false)
        .setFilter(_isCompleted);
    Navigator.of(context).pop();
  }
}
