class Estudiante {
  final int? id;
  final String matricula;
  final String nombres;
  final String apellidos;
  final String correo;

  Estudiante({
    this.id,
    required this.matricula,
    required this.nombres,
    required this.apellidos,
    required this.correo,
  });

  Map<String, dynamic> toJson() {
    return {
      "matricula": matricula,
      "nombres": nombres,
      "apellidos": apellidos,
      "correo": correo,
    };
  }

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'],
      matricula: json['matricula'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correo: json['correo'],
    );
  }
}