import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/components/tv_show_carousel.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

class TVShowsPage extends StatelessWidget {
  const TVShowsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          _PopularTVShows(),
          _AiringSoonTVShows(),
        ],
      ),
    );
  }
}

class _AiringSoonTVShows extends StatelessWidget {
  const _AiringSoonTVShows({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getAiringSoonTVShows),
        parserFn: (data) {
          return data['getAringSoonTvShows']['results'];
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final tvShows = result.parsedData;

        return TVShowCarousel(
          tvShows: tvShows,
          title: "Airing soon",
        );
      },
    );
  }
}

class _PopularTVShows extends StatelessWidget {
  const _PopularTVShows({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getPopularTVShows),
        parserFn: (data) {
          return data['getPopularTvShows']['results'];
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasException) {
          return Text(
            result.exception.toString(),
          );
        }

        final tvShows = result.parsedData;

        return TVShowCarousel(
          tvShows: tvShows,
          title: "Popular TV Shows",
        );
      },
    );
  }
}
