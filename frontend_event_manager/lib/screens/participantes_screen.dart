import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/evento.dart';

class ParticipantesScreen extends StatelessWidget {
  final Evento evento;
  final ApiService apiService = ApiService();

  ParticipantesScreen({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inscritos: ${evento.titulo}"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.getInscritos(evento.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay estudiantes inscritos aún."));
          } else {
            final inscritos = snapshot.data!;
            return ListView.builder(
              itemCount: inscritos.length,
              itemBuilder: (context, index) {
                final inscripcion = inscritos[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text("Estudiante ID: ${inscripcion['estudiante']}"),
                  subtitle: const Text("Inscripción confirmada"),
                );
              },
            );
          }
        },
      ),
    );
  }
}