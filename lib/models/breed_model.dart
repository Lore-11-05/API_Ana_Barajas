class Breed {
  final int id;
  final String name;
  final String temperament;
  final String imageUrl;

  Breed({
    required this.id,
    required this.name,
    required this.temperament,
    required this.imageUrl,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      // Convierte el id a String y luego intenta parsearlo a int.
      // Si falla, asigna 0 por defecto.
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Raza desconocida',
      temperament: json['temperament'] ?? 'Temperamento no especificado',
      imageUrl: json['image'] != null ? json['image']['url'] : '',
    );
  }
}
