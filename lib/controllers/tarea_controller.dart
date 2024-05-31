import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/models/tarea.dart';

class TareaController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool? _filterIsCompleted; // Atributo para guardar el filtro actual

  static const String collectionTareas = 'tarea';

  /// Agrega una nueva tarea a la colección de Firestore.
  Future<void> agregarTarea(
      String descripcion, Timestamp fechaVencimiento, bool estado) async {
    Tarea tarea = Tarea(
      id: "",
      descripcion: descripcion,
      fechaVencimiento: fechaVencimiento,
      fechaCreacion: Timestamp.now(),
      completada: estado,
    );
    try {
      DocumentReference ref =
          await _db.collection(collectionTareas).add(tarea.toJson());
      await ref.update({'id': ref.id});
    } catch (e) {
      _handleError(e, 'Error al agregar tarea');
    }
  }

  /// Obtiene los detalles de una tarea específica por ID.
  Future<Tarea> obtenerDetalleTarea(String id) async {
    try {
      DocumentSnapshot docSnapshot =
          await _db.collection(collectionTareas).doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        data['id'] = docSnapshot.id;
        return Tarea.fromJson(data);
      } else {
        throw Exception('La tarea no existe');
      }
    } catch (e) {
      return _handleError(e, 'Error al obtener detalles de la tarea');
    }
  }

  /// Elimina una tarea por ID.
  Future<void> eliminarTareaPorId(String id) async {
    try {
      await _db.collection(collectionTareas).doc(id).delete();
    } catch (e) {
      _handleError(e, 'Error al eliminar tarea');
    }
  }

  /// Actualiza una tarea existente.
  Future<void> actualizarTarea(String id, String descripcion,
      Timestamp fechaVencimiento, bool estado) async {
    try {
      await _db.collection(collectionTareas).doc(id).update({
        'descripcion': descripcion,
        'fechaVencimiento': fechaVencimiento,
        'completada': estado,
      });
    } catch (e) {
      _handleError(e, 'Error al actualizar tarea');
    }
  }

  /// Obtiene una lista de todas las tareas.
  Future<List<Tarea>> obtenerTareas() async {
    try {
      QuerySnapshot querySnapshot =
          await _db.collection(collectionTareas).get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs
          .map((doc) => Tarea.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _handleError(e, 'Error al obtener tareas');
    }
  }

  /// Establece el filtro para las tareas completadas.
  void setFilter(bool? isCompleted) {
    _filterIsCompleted = isCompleted;
    notifyListeners(); // Notificar a los widgets que escuchan este controlador
  }

  /// Obtiene una lista de tareas filtradas según el estado de completado.
  Future<List<Tarea>> obtenerTareasFiltradas() async {
    try {
      Query query = _db.collection(collectionTareas);
      if (_filterIsCompleted != null) {
        query = query.where('completada', isEqualTo: _filterIsCompleted);
      }
      QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => Tarea.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _handleError(e, 'Error al obtener tareas filtradas');
    }
  }

  /// Maneja los errores y los reporta.
  Future<T> _handleError<T>(Object e, String message) {
    if (e is FirebaseException) {
      throw Exception('$message: ${e.message}');
    } else {
      throw Exception('$message: $e');
    }
  }
}
