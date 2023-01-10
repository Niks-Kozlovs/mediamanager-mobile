import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/components/movie_carousel.dart';
import 'package:mediamanager_flutter/main.dart';
import 'package:mediamanager_flutter/queries/queries.dart';
import 'package:provider/provider.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          _MovieWatchlist(),
          SizedBox(height: 32),
          _PopularMovies(),
          SizedBox(height: 32),
          _TopRatedMovies(),
        ],
      ),
    );
  }
}

class _MovieWatchlist extends StatelessWidget {
  const _MovieWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedin = context.watch<CookiesProvider>().isLoggedin;

    if (!isLoggedin) {
      return Container(
        child: Text('Log in to see watchlist'),
      );
    }

    return Query(
      options: QueryOptions(
        document: gql(Queries.getMovieWatchlist),
        parserFn: (data) {
          return data['getMovieWatchlist'];
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
          title: "Watchlist",
        );
      },
    );
  }
}

class _PopularMovies extends StatelessWidget {
  const _PopularMovies();

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
  const _TopRatedMovies();

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
