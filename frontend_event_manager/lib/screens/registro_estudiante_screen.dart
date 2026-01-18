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
  
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  void _enviar() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ahora llamamos a la función dentro de un try
        await apiService.crearEstudiante({
          "matricula": _matriculaController.text,
          "nombres": _nombresController.text,
          "apellidos": _apellidosController.text,
          "correo": _correoController.text,
        });

        // Si la ejecución llega aquí, significa que fue exitoso (201 Created)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Estudiante registrado con éxito"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        // Aquí capturamos el 'throw' que definimos en el ApiService
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ Error: $e"), // Muestra el mensaje real del backend
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
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
            TextFormField(
              controller: _matriculaController, 
              decoration: const InputDecoration(labelText: "Matrícula"), 
              validator: (v) {
                if (v == null || v.isEmpty) return "La matrícula es obligatoria";
                if (v.length > 9) return "Máximo 9 caracteres";
                return null;
              },
            ),
            TextFormField(
              controller: _nombresController, 
              decoration: const InputDecoration(labelText: "Nombres"),
              validator: (v) => v!.isEmpty ? "El nombre es obligatorio" : null,
            ),
            TextFormField(
              controller: _apellidosController, 
              decoration: const InputDecoration(labelText: "Apellidos"),
              validator: (v) => v!.isEmpty ? "El apellido es obligatorio" : null,
            ),
            TextFormField(
              controller: _correoController, 
              decoration: const InputDecoration(labelText: "Correo Electrónico"),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return "El correo es obligatorio";
                if (!v.contains('@')) return "Ingresa un correo válido";
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviar, 
              child: const Text("Guardar Estudiante"),
            ),
          ],
        ),
      ),
    );
  }
}