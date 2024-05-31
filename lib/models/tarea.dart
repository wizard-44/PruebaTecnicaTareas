import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Tarea tareaFromJson(String str) => Tarea.fromJson(json.decode(str));

String tareaToJson(Tarea data) => json.encode(data.toJson());

class Tarea {
  String id;
  String descripcion;
  Timestamp fechaVencimiento;
  Timestamp fechaCreacion;
  bool completada;

  Tarea({
    required this.id,
    required this.descripcion,
    required this.fechaVencimiento,
    required this.fechaCreacion,
    required this.completada,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        id: json["id"],
        descripcion: json["descripcion"]??'',
        fechaVencimiento: json["fechaVencimiento"],
        fechaCreacion: json["fechaCreacion"],
        completada: json["completada"] ?? false,
      );


  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "fechaVencimiento": fechaVencimiento,
        "fechaCreacion": fechaCreacion,
        "completada":completada
      };
}
