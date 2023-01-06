import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/components/movie_carousel.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

class MovieRecommendations extends StatelessWidget {
  final int movieId;
  const MovieRecommendations({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getMovieRecommendations),
        variables: <String, dynamic>{
          'movieId': movieId,
        },
        parserFn: (data) => data['getMovieRecomendations']['results'],
      ),
      builder: (
        QueryResult result, {
        VoidCallback? refetch,
        FetchMore? fetchMore,
      }) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final movies = result.parsedData as List<dynamic>;

        if (movies.isEmpty) {
          return const SizedBox.shrink();
        }

        return MovieCarousel(
          movies: result.parsedData as List<dynamic>,
          title: "Recommended movies",
        );
      },
    );
  }
}
