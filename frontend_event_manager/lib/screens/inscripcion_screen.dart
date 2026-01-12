import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../models/estudiante.dart';
import '../services/api_service.dart';

class InscripcionScreen extends StatefulWidget {
  final Evento evento;
  const InscripcionScreen({super.key, required this.evento});

  @override
  State<InscripcionScreen> createState() => _InscripcionScreenState();
}

class _InscripcionScreenState extends State<InscripcionScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  
  // Controladores para capturar el texto
  final _matriculaCtrl = TextEditingController();
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 1. Creamos objeto estudiante
        Estudiante nuevo = Estudiante(
          matricula: _matriculaCtrl.text,
          nombres: _nombresCtrl.text,
          apellidos: _apellidosCtrl.text,
          correo: _correoCtrl.text,
        );

        // 2. Registrar/Obtener estudiante y luego inscribir
        final estudianteCreado = await apiService.registrarEstudiante(nuevo);
        final exito = await apiService.inscribir(estudianteCreado.id!, widget.evento.id);

        if (exito) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("¡Inscripción exitosa!")),
          );
          Navigator.pop(context); // Regresar al inicio
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscribirse a: ${widget.evento.titulo}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _matriculaCtrl, decoration: const InputDecoration(labelText: "Matrícula"), validator: (value) => value!.isEmpty ? "Requerido" : null),
              TextFormField(controller: _nombresCtrl, decoration: const InputDecoration(labelText: "Nombres"), validator: (value) => value!.isEmpty ? "Requerido" : null),
              TextFormField(controller: _apellidosCtrl, decoration: const InputDecoration(labelText: "Apellidos"), validator: (value) => value!.isEmpty ? "Requerido" : null),
              TextFormField(controller: _correoCtrl, decoration: const InputDecoration(labelText: "Correo"), validator: (value) => value!.isEmpty ? "Requerido" : null),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _enviarFormulario, child: const Text("Confirmar Inscripción")),
            ],
          ),
        ),
      ),
    );
  }
}