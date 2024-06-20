import 'dart:convert';
import 'package:http/http.dart' as http;
import 'foto.dart';

class ApiService {
  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse('https://picsum.photos/v2/list?page=2&limit=100'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat foto!');
    }
  }
}