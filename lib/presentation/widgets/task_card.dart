import 'package:flutter/material.dart';
import 'package:prueba_tecnica/models/tarea.dart';
import 'package:prueba_tecnica/utils/date_utils.dart' as custom_date_utils;

class TaskCard extends StatelessWidget {
  final Tarea tarea;
  const TaskCard({super.key, required this.tarea});

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 22, 22, 22),
  );

  static const TextStyle _valueStyle = TextStyle(
    fontSize: 13,
    color: Color.fromARGB(255, 22, 22, 22),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 7.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  custom_date_utils.DateUtils.getDayTimestamp(
                      tarea.fechaVencimiento),
                  style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF673AB7)),
                ),
                Text(
                  custom_date_utils.DateUtils.getMonthTimestamp(
                          tarea.fechaVencimiento)
                      .toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF673AB7)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow(title: 'Descripción:', value: tarea.descripcion),
              _detailRow(
                  title: 'Fecha creación:',
                  value: custom_date_utils.DateUtils.formatTimestamp(
                      tarea.fechaCreacion)),
              _detailRow(
                  title: 'Estado:',
                  value: tarea.completada ? 'Completada' : 'No completada'),
            ],
          ),
        )
      ],
    );
  }

  Widget _detailRow({required String title, required String value}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          Text(title, style: _titleStyle, textAlign: TextAlign.left),
          const SizedBox(height: 3),
          Text(value,
              style: _valueStyle,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis),
        ],
      );
}
