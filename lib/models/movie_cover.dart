class MovieCover{
  final int id;
  final String title;
  final String poster_path;
  final String backdrop_path;

  MovieCover({
    required this.id,
    required this.title,
    required this.poster_path,
    required this.backdrop_path
  });

  factory MovieCover.fromJson(Map<String, dynamic> json) => MovieCover(
        id: json['id'],
        title: json['title'],
        poster_path: json['poster_path'] ?? '',
        backdrop_path: json['backdrop_path'] ?? ''
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': poster_path,
    'backdrop_path': backdrop_path,
  };

  String display(){
    if(poster_path == '')
      return "https://image.tmdb.org/t/p/w185${backdrop_path}";

    return "https://image.tmdb.org/t/p/w185${poster_path}";
  }
}