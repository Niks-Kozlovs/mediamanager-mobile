import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

class MovieDetailsPage extends StatelessWidget {
  final String movieId;
  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(Queries.getMovieDetails),
          variables: <String, dynamic>{
            'movieId': int.tryParse(movieId),
          },
          parserFn: (data) => data['getMovieDetails'],
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

          final movie = result.parsedData as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}',
                ),
                Text(movie['title']),
                Text(movie['overview']),
              ],
            ),
          );
        },
      ),
    );
  }
}
