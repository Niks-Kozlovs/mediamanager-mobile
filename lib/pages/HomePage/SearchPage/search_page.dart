import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mediamanager_flutter/queries/queries.dart';

enum SearchType { movies, tvShows }

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchType = SearchType.movies;
  var _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            DropdownButton(
              value: _searchType,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _searchType = value;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: SearchType.movies,
                  child: Text("Movies"),
                ),
                DropdownMenuItem(
                  value: SearchType.tvShows,
                  child: Text("TV Shows"),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: _Results(
            searchQuery: _searchQuery,
            searchType: _searchType,
          ),
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  final String searchQuery;
  final SearchType searchType;

  const _Results({
    super.key,
    required this.searchQuery,
    required this.searchType,
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return const Center(
        child: Text(
          'Type in query to search',
        ),
      );
    }

    final query = searchType == SearchType.movies
        ? Queries.searchMovies
        : Queries.searchTVShows;

    return Query(
      options: QueryOptions(
        document: gql(query),
        variables: {"query": searchQuery},
        parserFn: (data) {
          final resultsKey = searchType == SearchType.movies
              ? 'searchMovies'
              : 'searchTVShows';
          return data[resultsKey]['results'];
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

        final results = result.parsedData;

        if (results.isEmpty) {
          return const Center(
            child: Text(
              'No results found',
            ),
          );
        }

        return _SearchResults(
          results: results,
          searchType: searchType,
        );
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List results;
  final SearchType searchType;
  const _SearchResults({
    super.key,
    required this.results,
    required this.searchType,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final result = results[index];
        return GestureDetector(
          onTap: () {
            final id = result['id'];
            if (searchType == SearchType.movies) {
              context.pushNamed('/movieDetails', params: {'id': id.toString()});
            } else {
              context
                  .pushNamed('/tvShowDetails', params: {'id': id.toString()});
            }
          },
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${result['poster_path']}',
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        result['overview'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: results.length,
    );
  }
}
