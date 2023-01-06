import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/pages/HomePage/MoviesPage/Components/movie_carousel.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          _PopularMovies(),
          SizedBox(height: 32),
          _TopRatedMovies(),
        ],
      ),
    );
  }
}

class _PopularMovies extends StatelessWidget {
  const _PopularMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getPopularMovies),
        parserFn: (data) {
          return data['getPopularMovies']['results'];
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasException) {
          return Center(
            child: Text(result.exception.toString()),
          );
        }

        return MovieCarousel(
          movies: result.parsedData,
          title: "Popular movies",
        );
      },
    );
  }
}

class _TopRatedMovies extends StatelessWidget {
  const _TopRatedMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getUpcomingMovies),
        parserFn: (data) {
          return data['getUpcoming']['results'];
        },
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasException) {
          return Center(
            child: Text(result.exception.toString()),
          );
        }

        return MovieCarousel(
          movies: result.parsedData,
          title: "Upcoming movies",
        );
      },
    );
  }
}
