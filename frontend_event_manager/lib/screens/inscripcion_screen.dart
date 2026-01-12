import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../services/api_service.dart';

class InscripcionScreen extends StatefulWidget {
  final Evento evento;
  const InscripcionScreen({super.key, required this.evento});

  @override
  State<InscripcionScreen> createState() => _InscripcionScreenState();
}

class _InscripcionScreenState extends State<InscripcionScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _estudiantes = [];
  int? _estudianteSeleccionado;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _obtenerEstudiantes();
  }

  void _obtenerEstudiantes() async {
    try {
      final lista = await _apiService.getEstudiantes();
      setState(() {
        _estudiantes = lista;
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar estudiantes")),
      );
    }
  }

  void _procesarInscripcion() async {
    if (_estudianteSeleccionado == null) return;

    final exito = await _apiService.inscribir(
      _estudianteSeleccionado!,
      widget.evento.id,
    );

    if (mounted) {
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Inscripción exitosa!")),
        );
        Navigator.pop(context, true); // Regresa y avisa que hubo éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: El estudiante ya está inscrito o no hay cupo")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Inscripción")),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(widget.evento.titulo, 
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("📅 ${widget.evento.fecha}"),
                          Text("👥 Cupos disponibles: ${widget.evento.cuposDisponibles}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Selecciona el estudiante:", 
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: _estudianteSeleccionado,
                    hint: const Text("Seleccionar un estudiante"),
                    items: _estudiantes.map((e) {
                      return DropdownMenuItem<int>(
                        value: e['id'],
                        child: Text("${e['nombres']} ${e['apellidos']}"),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _estudianteSeleccionado = val),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _estudianteSeleccionado == null ? null : _procesarInscripcion,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text("INSCRIBIRME AHORA"),
                  ),
                ],
              ),
            ),
    );
  }
}