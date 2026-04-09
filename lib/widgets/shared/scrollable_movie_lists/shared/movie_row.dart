import 'package:flutter/material.dart';

import 'movie_cover_card.dart';
import '../../../../models/movie_cover.dart';

class MovieRow extends StatelessWidget {
  final List<MovieCover>movies;

  const MovieRow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index){
            return MovieCoverCard(movieCover: movies[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              Container(
                width: 10,
              )
      ),
    );
  }
}
