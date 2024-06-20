import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'foto.dart';
import 'api_service.dart';

void main() {
  runApp(AplikasiFotoEstetik());
}

class AplikasiFotoEstetik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estetika Foto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PhotosPage(),
    );
  }
}

class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  late Future<List<Photo>> futurePhotos;
  List<Photo> photos = [];
  List<Photo> filteredPhotos = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePhotos = ApiService().fetchPhotos();
    futurePhotos.then((photoList) {
      setState(() {
        photos = photoList;
        filteredPhotos = photoList;
      });
    });

    searchController.addListener(() {
      filterPhotos();
    });
  }

  void filterPhotos() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPhotos = photos.where((photo) {
        return photo.author.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estetika Foto'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan penulis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Photo>>(
                future: futurePhotos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Foto tidak ditemukan!'));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredPhotos.length,
                      itemBuilder: (context, index) {
                        Photo photo = filteredPhotos[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: GridTile(
                              child: CachedNetworkImage(
                                imageUrl: photo.downloadUrl,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                              footer: GridTileBar(
                                backgroundColor: Colors.black54,
                                title: Text(
                                  photo.author,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}