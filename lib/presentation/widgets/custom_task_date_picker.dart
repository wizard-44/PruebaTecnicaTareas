import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final TextEditingController controller;
  final String? label;

  const DatePickerFormField({
    super.key,
    required this.onDateSelected,
    required this.controller,
    this.label,
  });

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      readOnly: true, // Hace el campo de texto de solo lectura
      onTap: _showDatePicker,
    );
  }

  Future<void> _showDatePicker() async {
    DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100), // Puedes establecer una fecha final adecuada
    );

    if (pickedDate != null) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      widget.onDateSelected(pickedDate);
    }
  }
}
