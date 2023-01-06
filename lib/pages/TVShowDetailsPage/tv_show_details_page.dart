import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('TV Show Details $tvShowId'),
      ),
    );
  }
}
