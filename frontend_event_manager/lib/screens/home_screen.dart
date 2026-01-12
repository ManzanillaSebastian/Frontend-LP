import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../services/api_service.dart';
import 'inscripcion_screen.dart';
import 'participantes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Evento>> futureEventos;

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  // Función para (re)cargar los datos desde el backend
  void _cargarEventos() {
    setState(() {
      futureEventos = apiService.getEventos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos Universitarios'),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarEventos,
            tooltip: 'Actualizar lista',
          )
        ],
      ),
      body: FutureBuilder<List<Evento>>(
        future: futureEventos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: _cargarEventos,
                      child: const Text('Reintentar'),
                    )
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay eventos disponibles actualmente.'));
          } else {
            final eventos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                final bool sinCupo = evento.cuposDisponibles <= 0;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      evento.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text("📅 Fecha: ${evento.fecha}"),
                        Text("⏰ Horario: ${evento.horaInicio} - ${evento.horaFin}"),
                        Text(
                          "👥 Cupos: ${evento.cuposDisponibles} / ${evento.cupoMaximo}",
                          style: TextStyle(
                            color: sinCupo ? Colors.red : Colors.green[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para ver la lista de participantes
                        IconButton(
                          icon: const Icon(Icons.people, color: Colors.blueGrey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParticipantesScreen(evento: evento),
                              ),
                            );
                          },
                          tooltip: 'Ver inscritos',
                        ),
                        const VerticalDivider(),
                        // Botón para ir al formulario de inscripción
                        IconButton(
                          icon: Icon(
                            sinCupo ? Icons.block : Icons.app_registration,
                            color: sinCupo ? Colors.grey : Colors.blue,
                          ),
                          onPressed: sinCupo 
                            ? null 
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InscripcionScreen(evento: evento),
                                  ),
                                ).then((_) => _cargarEventos()); // Recarga al volver
                              },
                          tooltip: sinCupo ? 'Sin cupos' : 'Inscribirme',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}