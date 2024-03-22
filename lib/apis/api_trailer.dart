import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieTrailerFetcher {
 static const String apiKey = '6b89756e6ddbcfb4d74483d65b5b45ff'; 
 static const String baseUrl = 'https://api.themoviedb.org/3/movie/';

 Future<List<String>> getTrailers(int movieId) async {
    List<String> trailers = [];
    final response = await http.get(Uri.parse('$baseUrl$movieId/videos?api_key=$apiKey'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var results = data['results'];
      for (var video in results) {
        if (video['type'] == 'Trailer' && video['site'] == 'YouTube') {
          trailers.add('https://www.youtube.com/watch?v=${video['key']}');
        }
      }
    } else {
      throw Exception('Failed to load trailers.');
    }
    return trailers;
 }
}