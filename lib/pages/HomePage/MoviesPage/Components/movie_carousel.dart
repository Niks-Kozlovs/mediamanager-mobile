import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MovieCarousel extends StatefulWidget {
  final List movies;
  final String title;
  const MovieCarousel({
    Key? key,
    required this.movies,
    required this.title,
  }) : super(key: key);

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  int movieIndex = 0;
  @override
  Widget build(BuildContext context) {
    final movie = widget.movies[movieIndex];

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
            movie['title'],
          ),
        ),
        CarouselSlider(
          items: widget.movies
              .map<Widget>((movie) => Image.network(
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    fit: BoxFit.cover,
                  ))
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                movieIndex = index;
              });
            },
            initialPage: movieIndex,
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
