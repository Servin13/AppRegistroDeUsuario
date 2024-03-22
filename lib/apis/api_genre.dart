import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieGenreFetcher {
  static const String apiKey = '6b89756e6ddbcfb4d74483d65b5b45ff';
  static const String baseUrl = 'https://api.themoviedb.org/3/movie/';

  Future<List<String>> getGenres(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl$movieId?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var genres = data['genres'];
      List<String> genreNames = [];
      for (var genre in genres) {
        genreNames.add(genre['name']);
      }
      return genreNames;
    } else {
      throw Exception('Failed to load movie genres.');
    }
  }
}
