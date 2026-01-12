import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CrearEventoScreen extends StatefulWidget {
  const CrearEventoScreen({super.key});

  @override
  State<CrearEventoScreen> createState() => _CrearEventoScreenState();
}

class _CrearEventoScreenState extends State<CrearEventoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _cupoController = TextEditingController();
  
  DateTime _fecha = DateTime.now();
  TimeOfDay _inicio = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _fin = const TimeOfDay(hour: 10, minute: 0);

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      // Formatear datos para Django
      final datos = {
        "titulo": _tituloController.text,
        "descripcion": _descController.text,
        "fecha": "${_fecha.year}-${_fecha.month.toString().padLeft(2, '0')}-${_fecha.day.toString().padLeft(2, '0')}",
        "hora_inicio": "${_inicio.hour.toString().padLeft(2, '0')}:${_inicio.minute.toString().padLeft(2, '0')}:00",
        "hora_fin": "${_fin.hour.toString().padLeft(2, '0')}:${_fin.minute.toString().padLeft(2, '0')}:00",
        "cupo_maximo": int.parse(_cupoController.text),
      };

      bool exito = await _apiService.crearEvento(datos);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(exito ? "Evento creado con éxito" : "Error al crear evento")),
        );
        if (exito) Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Nuevo Evento")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _tituloController, decoration: const InputDecoration(labelText: "Título"), validator: (v) => v!.isEmpty ? "Requerido" : null),
            TextFormField(controller: _descController, decoration: const InputDecoration(labelText: "Descripción"), maxLines: 3),
            TextFormField(controller: _cupoController, decoration: const InputDecoration(labelText: "Cupo Máximo"), keyboardType: TextInputType.number),
            const Divider(height: 30),
            ListTile(
              title: Text("Fecha: ${_fecha.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(context: context, initialDate: _fecha, firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (picked != null) setState(() => _fecha = picked);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("Inicio: ${_inicio.format(context)}"),
                    onTap: () async {
                      TimeOfDay? t = await showTimePicker(context: context, initialTime: _inicio);
                      if (t != null) setState(() => _inicio = t);
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text("Fin: ${_fin.format(context)}"),
                    onTap: () async {
                      TimeOfDay? t = await showTimePicker(context: context, initialTime: _fin);
                      if (t != null) setState(() => _fin = t);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _guardar, child: const Text("Publicar Evento")),
          ],
        ),
      ),
    );
  }
}