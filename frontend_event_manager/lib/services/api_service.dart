import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evento.dart';
import '../models/estudiante.dart';

class ApiService {
  // Asegúrate de actualizar esta URL si Codespaces te da una nueva al reiniciar!!!!!
  static const String baseUrl = "https://special-pancake-qg7wpxgv9pxf4j5x-8000.app.github.dev/";

  // 1. OBTENER LISTA DE EVENTOS
  Future<List<Evento>> getEventos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/eventos/'));
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

  // 2. CREAR NUEVO EVENTO (Para CrearEventoScreen)
  Future<bool> crearEvento(Map<String, dynamic> datos) async {
    final response = await http.post(
      Uri.parse('$baseUrl/eventos/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(datos),
    );
    return response.statusCode == 201;
  }

  // 3. OBTENER LISTA DE ESTUDIANTES (Para el Dropdown de InscripcionScreen)
  Future<List<dynamic>> getEstudiantes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/estudiantes/'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Error al obtener estudiantes";
      }
    } catch (e) {
      throw "Error de conexión: $e";
    }
  }

  // 4. REGISTRAR NUEVO ESTUDIANTE (Para RegistroEstudianteScreen)
  Future<void> crearEstudiante(Map<String, dynamic> datos) async {
    final response = await http.post(
      Uri.parse('$baseUrl/estudiantes/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(datos),
    );

    if (response.statusCode != 201) {
      final errorData = jsonDecode(response.body);
      
      String mensajeError = "Error en el registro";
      
      if (errorData is Map) {
        // Tomamos el primer error que aparezca en el JSON
        var primerError = errorData.values.first;
        mensajeError = primerError is List ? primerError[0] : primerError.toString();
      }
      
      throw mensajeError; // Esto envía el error a la pantalla
    }
  }

  // 5. REGISTRAR UNA INSCRIPCIÓN (Para el botón confirmar de InscripcionScreen)
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
      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  // 6. OBTENER PARTICIPANTES DE UN EVENTO (Para ParticipantesScreen)
  Future<List<dynamic>> getInscritos(int eventoId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/eventos/$eventoId/inscripciones/'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Error al obtener inscritos";
      }
    } catch (e) {
      throw "Error de conexión: $e";
    }
  }
}