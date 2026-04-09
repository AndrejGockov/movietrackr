import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/gallery.dart';
import '../models/movie.dart';
import '../models/movie_cover.dart';

class TheMovieDBService {
  TheMovieDBService._privateConstructor();

  static final TheMovieDBService instance =
      TheMovieDBService._privateConstructor();

  factory TheMovieDBService() {
    return instance;
  }

  String baseUrl = 'https://api.themoviedb.org/3';
  String apiKey = 'api_key=${dotenv.env['API_KEY']}';
  // String page = '&page=';
  String language = '&language=en';

  Future<Movie> findMovieById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$id?$apiKey$language'),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load movie");
    }

    final movie = jsonDecode(response.body);
    return Movie.fromJson(movie);
  }

  Future<Gallery> findGalleryById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$id/images?$apiKey$language'),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load gallery");
    }

    final gallery = jsonDecode(response.body);
    return Gallery.fromJson(gallery);
  }

  Future<List<MovieCover>> getMoviesByType(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/$type?$apiKey'));

    if (response.statusCode != 200) {
      return [];
    }

    final List data = jsonDecode(response.body)['results'];

    return data.map((json) => MovieCover.fromJson(json)).toList();
  }

  Future<List<MovieCover>> getPage(int page, String path, String query) async {
    final response;

    if (query == '') {
      response = await http.get(Uri.parse('$baseUrl/$path?$apiKey&page=$page'));
    } else {
      response = await http.get(
        Uri.parse('$baseUrl/$path?$apiKey&query=$query&page=$page'),
      );
    }

    if (response.statusCode != 200) {
      return [];
    }

    final List data = jsonDecode(response.body)['results'];

    return data.map((json) => MovieCover.fromJson(json)).toList();
  }

  Future<int> getTotalPages(int page, String path, String query) async {
    final response;

    if (query == '') {
      response = await http.get(Uri.parse('$baseUrl/$path?$apiKey&page=$page'));
    } else {
      response = await http.get(
        Uri.parse('$baseUrl/$path?$apiKey&query=$query&page=$page'),
      );
    }

    if (response.statusCode != 200) {
      return 1;
    }

    return jsonDecode(response.body)['total_pages'] ?? 1;
  }

  Future<List<MovieCover>> searchMovies(int page, String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?$apiKey&query=$query&page=$page'),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final List data = jsonDecode(response.body)['results'];

    return data.map((json) => MovieCover.fromJson(json)).toList();
  }
}
