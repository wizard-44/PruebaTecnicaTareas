import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateUtils {
  // Almacena formateadores como campos estáticos para reutilizar
  static final DateFormat _dayFormatter = DateFormat('dd', 'es_ES');
  static final DateFormat _monthFormatter =
      DateFormat('MMM', 'es_ES'); // Abreviatura del mes
  static final DateFormat _fullDateFormatter =
      DateFormat('EEEE, d MMMM y', 'es_ES');

  /// Obtiene el día del mes desde un Timestamp.
  /// Ejemplo de retorno: "20"
  static String getDayTimestamp(Timestamp timestamp) {
    return _dayFormatter.format(_convertTimestamp(timestamp));
  }

  /// Obtiene el nombre abreviado del mes desde un Timestamp.
  /// Ejemplo de retorno: "ene"
  static String getMonthTimestamp(Timestamp timestamp) {
    return _monthFormatter.format(_convertTimestamp(timestamp));
  }

  /// Formatea completamente un Timestamp a una cadena legible.
  /// Ejemplo de retorno: "Miércoles, 20 de enero de 2024"
  static String formatTimestamp(Timestamp timestamp) {
    return _fullDateFormatter.format(_convertTimestamp(timestamp));
  }

  // Método privado para convertir Timestamp a DateTime
  static DateTime _convertTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
