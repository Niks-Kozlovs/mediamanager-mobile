class Queries {
  static const String login = """
    mutation Login(\$credentials: loginCredentials!) {
      login(credentials: \$credentials) {
        username
      }
    }
  """;

  static const String getPopularMovies = """
    query GetPopularMovies {
      getPopularMovies {
        results {
          poster_path
          adult
          overview
          release_date
          genre_ids
          id
          original_title
          original_language
          title
          backdrop_path
          popularity
          vote_count
          video
          vote_average
        }
      }
    }
  """;

  static const String getTopRatedMovies = """
    query GetTopRated {
      getTopRated {
        results {
          poster_path
          adult
          overview
          release_date
          genre_ids
          id
          original_title
          original_language
          title
          backdrop_path
          popularity
          vote_count
          video
          vote_average
        }
      }
    }
  """;

  static const String getUpcomingMovies = """
    query GetUpcoming {
      getUpcoming {
        results {
          poster_path
          adult
          overview
          release_date
          genre_ids
          id
          original_title
          original_language
          title
          backdrop_path
          popularity
          vote_count
          video
          vote_average
        }
      }
    }
  """;

  static const String getMovieDetails = """
    query GetMovieDetails(\$movieId: Int!) {
      getMovieDetails(movieId: \$movieId) {
        poster_path
        adult
        overview
        release_date
        genre_ids
        id
        original_title
        original_language
        title
        backdrop_path
        popularity
        vote_count
        video
        vote_average
        budget
        homepage
        imdb_id
        revenue
        runtime
        status
        tagline
      }
    }
  """;
}
