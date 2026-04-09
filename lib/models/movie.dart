import 'genre.dart';
import 'production_company.dart';

class Movie {
  final int id;
  final String imdb_id;
  final String homepage;
  final String title;
  final String tagline;
  final String original_title;
  final String poster_path;
  final String backdrop_path;
  final String overview;
  final String status;
  final DateTime release_date;
  final int runtime;
  final int budget;
  final int revenue;
  final List<Genre> genres;
  List<String>production_companies;
  List<ProductionCountry>production_countries;

  Movie({
    required this.id,
    required this.imdb_id,
    required this.homepage,
    required this.title,
    required this.tagline,
    required this.original_title,
    required this.poster_path,
    required this.backdrop_path,
    required this.overview,
    required this.release_date,
    required this.status,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.genres,
    required this.production_companies,
    required this.production_countries,
  });

  factory Movie.fromJson(Map<String, dynamic> json) =>
      Movie(
          id: json['id'],
          imdb_id: json['imdb_id'] ?? '',
          homepage: json['homepage'] ?? '',
          title: json['title'] ?? '',
          tagline: json['tagline'] ?? '',
          original_title: json['original_title'],
          poster_path: json['poster_path'] ?? '',
          backdrop_path: json['backdrop_path'] ?? '',
          overview: json['overview'] ?? '',
          status: json['status'] ?? '',
          release_date:
          DateTime.tryParse(json["release_date"] ?? '') ?? DateTime(0, 1, 1),
          runtime: json['runtime'] ?? 0,
          budget: json['budget'] ?? 0,
          revenue: json['revenue'] ?? 0,
          genres: List<Genre>.from(
              json["genres"].map((x) => Genre.fromJson(x))),
          production_countries: List<ProductionCountry>.from(
              json['production_countries'].map((x) => ProductionCountry.fromJson(x))),
          production_companies: json['production_companies'] != null
              ? List<String>.from(
              json['production_companies'].map((x) => x['name'] as String))
              : []
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imdb_id': imdb_id,
    'homepage': homepage,
    'title': title,
    'tagline': tagline,
    'original_title': original_title,
    'poster_path': poster_path,
    'backdrop_path': backdrop_path,
    'overview': overview,
    'status': status,
    'release_date':
        "${release_date.year.toString().padLeft(4, '0')}-${release_date.month.toString().padLeft(2, '0')}-${release_date.day.toString().padLeft(2, '0')}",
    'genres': genres.map((g) => g.toJson()).toList(),
    'runtime': runtime,
    'production_countries': production_countries.map((x) => x.toJson()).toList(),
    'production_companies': production_companies.map((name) => {
      'name': name}).toList(),
  };

  String display(String image) {
    return "https://image.tmdb.org/t/p/original$image";
  }
}
