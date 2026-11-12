import 'package:flutter/material.dart';

import 'models/breed_model.dart';
import 'services/dog_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog App',
      home: const BreedListPage(),
    );
  }
}

// --- PANTALLA 1: LISTA DE PERROS ---
class BreedListPage extends StatefulWidget {
  const BreedListPage({super.key});

  @override
  State<BreedListPage> createState() => _BreedListPageState();
}

class _BreedListPageState extends State<BreedListPage> {
  final DogService _dogService = DogService();
  late Future<List<Breed>> _breedsFuture;

  @override
  void initState() {
    super.initState();
    _breedsFuture = _dogService.fetchBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razas de Perros'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Breed>>(
        future: _breedsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos'));
          }

          final breeds = snapshot.data!;
          return ListView.builder(
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              final breed = breeds[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  // AQUÍ ARREGLAMOS LAS IMÁGENES CON UN ERRORBUILDER
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        breed.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Si la imagen falla (por CORS en web), muestra una huella
                          return const Icon(
                            Icons.pets,
                            color: Colors.blueAccent,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    breed.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    breed.temperament,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // AQUÍ AGREGAMOS LA ACCIÓN DE CLIC
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navegar a la pantalla de detalles pasando el objeto breed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DogDetailPage(breed: breed),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- PANTALLA 2: DETALLES DEL PERRO ---
class DogDetailPage extends StatelessWidget {
  final Breed breed;

  const DogDetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen grande del perro
            Container(
              height: 300,
              color: Colors.grey[200],
              child: Image.network(
                breed.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Temperamento:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(breed.temperament, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Text(
                    'ID de la API:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    breed.id.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
