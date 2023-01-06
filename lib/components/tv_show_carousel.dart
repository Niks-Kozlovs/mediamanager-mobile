import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TVShowCarousel extends StatefulWidget {
  final List tvShows;
  final String title;
  const TVShowCarousel({
    Key? key,
    required this.tvShows,
    required this.title,
  }) : super(key: key);

  @override
  State<TVShowCarousel> createState() => _TVShowCarouselState();
}

class _TVShowCarouselState extends State<TVShowCarousel> {
  int tvShowIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tvShow = widget.tvShows[tvShowIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Center(
          child: Text(
            tvShow['name'],
          ),
        ),
        CarouselSlider(
          items: widget.tvShows
              .map<Widget>((movie) => _MovieCard(tvShow: movie))
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                tvShowIndex = index;
              });
            },
            initialPage: tvShowIndex,
            aspectRatio: 2 / 3,
            height: 300,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.45,
          ),
        ),
      ],
    );
  }
}

class _MovieCard extends StatelessWidget {
  final dynamic tvShow;
  const _MovieCard({
    Key? key,
    required this.tvShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('/tvShowDetails', params: {
          'id': tvShow['id'].toString(),
        });
      },
      child: Image.network(
        'https://image.tmdb.org/t/p/w500${tvShow['poster_path']}',
        fit: BoxFit.cover,
      ),
    );
  }
}
