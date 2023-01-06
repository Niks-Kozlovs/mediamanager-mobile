import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/pages/TVShowDetailsPage/components/tv_show_recommendations.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

class TVShowDetailsPage extends StatelessWidget {
  final String tvShowId;

  const TVShowDetailsPage({
    super.key,
    required this.tvShowId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Show Details'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(Queries.getTVShowDetails),
          variables: <String, dynamic>{
            'tvShowId': tvShowId,
          },
          parserFn: (data) {
            return data['getTVShowDetails'];
          },
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final tvShow = result.parsedData;

          final backdropPath = tvShow['backdrop_path'] as String?;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (backdropPath?.isNotEmpty == true)
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${tvShow['backdrop_path']}',
                  ),
                Text(tvShow['name']),
                Text(tvShow['overview']),
                TVShowRecommendations(tvShowId: tvShowId)
              ],
            ),
          );
        },
      ),
    );
  }
}
