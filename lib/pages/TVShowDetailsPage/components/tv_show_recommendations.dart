import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/components/tv_show_carousel.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

class TVShowRecommendations extends StatelessWidget {
  final String tvShowId;
  const TVShowRecommendations({
    super.key,
    required this.tvShowId,
  });

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getTVShowRecommendations),
        variables: <String, dynamic>{
          'tvShowId': int.parse(tvShowId),
        },
        parserFn: (data) => data['getTvShowRecommendations']['results'],
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

        final tvShows = result.parsedData as List<dynamic>;

        if (tvShows.isEmpty) {
          return const SizedBox.shrink();
        }

        return TVShowCarousel(
          tvShows: tvShows,
          title: "Recommended tv shows",
        );
      },
    );
  }
}
