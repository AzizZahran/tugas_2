class Photo {
  final String id;
  final String author;
  final String url;
  final String downloadUrl;

  Photo({required this.id, required this.author, required this.url, required this.downloadUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      author: json['author'],
      url: json['url'],
      downloadUrl: json['download_url'],
    );
  }
}