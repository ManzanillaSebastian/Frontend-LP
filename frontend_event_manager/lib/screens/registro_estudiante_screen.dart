import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroEstudianteScreen extends StatefulWidget {
  const RegistroEstudianteScreen({super.key});

  @override
  State<RegistroEstudianteScreen> createState() => _RegistroEstudianteScreenState();
}

class _RegistroEstudianteScreenState extends State<RegistroEstudianteScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  
  // Controladores para capturar el texto
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  void _enviar() async {
    if (_formKey.currentState!.validate()) {
      final exito = await apiService.crearEstudiante({
        "matricula": _matriculaController.text,
        "nombres": _nombresController.text,
        "apellidos": _apellidosController.text,
        "correo": _correoController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(exito ? "Estudiante registrado" : "Error al registrar")),
        );
        if (exito) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Estudiante")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _matriculaController, decoration: const InputDecoration(labelText: "Matrícula"), validator: (v) => v!.isEmpty ? "Obligatorio" : null),
            TextFormField(controller: _nombresController, decoration: const InputDecoration(labelText: "Nombres")),
            TextFormField(controller: _apellidosController, decoration: const InputDecoration(labelText: "Apellidos")),
            TextFormField(controller: _correoController, decoration: const InputDecoration(labelText: "Correo Electrónico")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _enviar, child: const Text("Guardar Estudiante")),
          ],
        ),
      ),
    );
  }
}