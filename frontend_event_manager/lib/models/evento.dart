class Evento {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final int cupoMaximo;
  final int cuposDisponibles;

  Evento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.cupoMaximo,
    required this.cuposDisponibles,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      cupoMaximo: json['cupo_maximo'] ?? 0,
      cuposDisponibles: json['cupos_disponibles'] ?? 0,
    );
  }
}