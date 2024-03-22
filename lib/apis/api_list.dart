import 'package:dio/dio.dart';
import 'package:pmsn2024/model/popular_model.dart';

class ApiFavorites {
  final String apiKey = '6b89756e6ddbcfb4d74483d65b5b45ff';
  final String sessionId ='a9fc10f25a1a0437dfb4248c1e95bc7e59677cb8'; // Session ID existente
  final String authorizedRequestToken ='266d7a2ff8aba3619c5f805f00f2a203e0e27318'; // Token autorizado

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/account/21050747/favorite/movies',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> favoriteMovies =
            List<Map<String, dynamic>>.from(response.data['results']);
        return favoriteMovies;
      } else {
        throw Exception('Failed to retrieve favorite movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21050747/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      if (response.statusCode == 200) {
        print('Película agregada a favoritos');
      } else {
        print('Película agregada a favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21050747/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      if (response.statusCode == 200) {
        print('Película eliminada de favoritos');
      } else {
        throw Exception('Error al eliminar la película de favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<PopularModel?> getMovieDetails(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=6b89756e6ddbcfb4d74483d65b5b45ff&language=es',
      );

      if (response.statusCode == 200) {
        return PopularModel.fromMap(response
            .data);
      } else {
        throw Exception('Failed to retrieve movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
