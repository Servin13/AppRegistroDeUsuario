import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieCastFetcher {
  static const String apiKey = '6b89756e6ddbcfb4d74483d65b5b45ff';
  static const String baseUrl = 'https://api.themoviedb.org/3/movie/';

  Future<List<Map<String, dynamic>>> getCastWithImages(int movieId) async {
    List<Map<String, dynamic>> castWithImages = [];
    final response = await http.get(Uri.parse('$baseUrl$movieId/credits?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var results = data['cast'];
      for (var actor in results) {
        if (actor['order'] <= 20) {
          var actorInfo = {
            'name': actor['name'],
            'character': actor['character'],
            'profilePath': actor['profile_path'] != null ? 'https://image.tmdb.org/t/p/w500${actor['profile_path']}' : null
          };
          castWithImages.add(actorInfo);
        }
      }
    } else {
      throw Exception('Failed to load cast.');
    }
    return castWithImages;
  }

  Future<List<String>> getReviews(int movieId) async {
    List<String> reviews = [];
    final response = await http.get(Uri.parse('$baseUrl$movieId/reviews?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var results = data['results'];
      for (var review in results) {
        reviews.add('${review['author']}:\n${review['content']}'); 
      }
    } else {
      throw Exception('Failed to load reviews.');
    }

    String allReviews = reviews.join(', ');
    return [allReviews];
  }

  Future<Map<String, dynamic>> getProviders(int movieId) async {
    Map<String, dynamic> providers = {};
    final response = await http.get(Uri.parse('$baseUrl$movieId/watch/providers?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        providers = data['results'];
      }
    } else {
      throw Exception('Failed to load providers.');
    }
    return providers;
  }
}

