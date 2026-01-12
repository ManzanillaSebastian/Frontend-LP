import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/evento.dart';
import '../models/estudiante.dart';

class ApiService {
  static const String baseUrl = "https://scaling-spoon-pqjxp6q7jp626qr-8000.app.github.dev/";

  // 1. Obtener lista de eventos
  Future<List<Evento>> getEventos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Evento.fromJson(item)).toList();
      } else {
        throw "Error del servidor: ${response.statusCode}";
      }
    } catch (e) {
      throw "No se pudo conectar al backend: $e";
    }
  }

  // 2. Registrar o buscar estudiante
  Future<Estudiante> registrarEstudiante(Estudiante estudiante) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estudiantes/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(estudiante.toJson()),
    );

    if (response.statusCode == 201) {
      return Estudiante.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      // Si el backend devuelve error porque la matrícula ya existe, 
      // podrías manejar una lógica para obtener ese ID.
      throw "El estudiante ya existe o los datos son inválidos.";
    } else {
      throw "Error al registrar estudiante.";
    }
  }

  // 3. Crear la inscripción
  Future<bool> inscribir(int estudianteId, int eventoId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inscripciones/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "estudiante": estudianteId,
          "evento": eventoId,
        }),
      );

      // Si el backend responde 201 Created, devolvemos true
      if (response.statusCode == 201) {
        return true;
      } else {
        // Si hay un error, lanzamos el mensaje del backend
        final errorData = jsonDecode(response.body);
        throw errorData is List ? errorData[0] : errorData.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  // 4. Obtener participantes de un evento específico
  Future<List<dynamic>> getInscritos(int eventoId) async {
    try {
      // Usamos el endpoint: /eventos/{id}/inscripciones/
      final response = await http.get(Uri.parse('$baseUrl/eventos/$eventoId/inscripciones/'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retorna la lista de inscripciones
      } else {
        throw "Error al obtener inscritos";
      }
    } catch (e) {
      throw "Error de conexión: $e";
    }
  }
}