import 'package:flutter/material.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/apis/api_actors.dart';
import 'package:pmsn2024/apis/api_list.dart';
import 'package:pmsn2024/apis/api_trailer.dart';
import 'package:pmsn2024/apis/api_genre.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({Key? key}) : super(key: key);

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  late YoutubePlayerController _controller;
  bool isLoading = true;
  List<Map<String, dynamic>> cast = [];
  List<String> movieGenres = [];
  bool isFavorite = false;
  final ApiFavorites apiFavorites = ApiFavorites();
  Key favoriteKey = UniqueKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTrailer();
    _loadCast();
    _loadGenres();
    _checkIsFavorite();
  }

  void _loadTrailer() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final trailerFetcher = MovieTrailerFetcher();

    try {
      final trailers = await trailerFetcher.getTrailers(popularModel.id!);
      if (trailers.isNotEmpty) {
        final trailerId = YoutubePlayer.convertUrlToId(trailers[0]);
        if (trailerId != null) {
          setState(() {
            _controller = YoutubePlayerController(
              initialVideoId: trailerId,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error cargando el trailer: $e');
    }
  }

  void _toggleFavorite() async {
  final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
  try {
    if (isFavorite) {
      await apiFavorites.removeFromFavorites(popularModel.id!);
    } else {
      await apiFavorites.addToFavorites(popularModel.id!);
    }
    
    _checkIsFavorite();
    
    setState(() {
      favoriteKey = UniqueKey();
    });
  } catch (e) {
    print('Error: $e');
  }
}

 void _checkIsFavorite() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    try {
      final favoriteMovies = await apiFavorites.getFavoriteMovies();
      setState(() {
        isFavorite = favoriteMovies.any((movie) => movie['id'] == popularModel.id);
      });
    } catch (e) {
      print('Error al verificar si la película está en favoritos: $e');
    }
 }

  void _loadCast() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final castFetcher = MovieCastFetcher();

    try {
      cast = await castFetcher.getCastWithImages(popularModel.id!);
    } catch (e) {
      print('Error cargando el elenco: $e');
    }
  }

  void _loadGenres() async {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;
    final genreFetcher = MovieGenreFetcher();

    try {
      final genres = await genreFetcher.getGenres(popularModel.id!);
      setState(() {
        movieGenres = genres;
      });
    } catch (e) {
      print('Error cargando los géneros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularModel = ModalRoute.of(context)!.settings.arguments as PopularModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          'Acerca De La Pelicula',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            key: favoriteKey, 
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite, 
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              'https://image.tmdb.org/t/p/w500/${popularModel.backdropPath}',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.5),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          popularModel.title ?? 'Título no disponible',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              popularModel.voteAverage!.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '\n${popularModel.overview}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Text(
                  'Actores',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cast.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            cast[index]['profilePath'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(cast[index]['profilePath']),
                                  )
                                : Icon(Icons.person, size: 50, color: Colors.white),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cast[index]['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'como ${cast[index]['character']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Géneros',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: movieGenres.map((genre) {
                    return Chip(
                      label: Text(
                        genre,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black,
                    );
                  }).toList(),
                ),
                Text(
                  'Trailer',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                isLoading
                    ? CircularProgressIndicator()
                    : _controller != null
                        ? YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                          )
                        : Text('No se encontró ningún trailer'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



















