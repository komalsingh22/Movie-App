import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widget/description.dart';


class TrendingMovies extends StatelessWidget {
  const TrendingMovies({super.key, required this.trending});
  final List trending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ModifiedText(
            text: '🔥 Trending Movies',
            color: Colors.white,
            size: 26,
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 320,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: trending.length,
              itemBuilder: (context, index) {
                if (trending[index] is! Map<String, dynamic>) {
                  return const SizedBox.shrink();
                }
                
                final movie = trending[index] as Map<String, dynamic>;
                if (movie['title'] == null) {
                  return const SizedBox.shrink();
                }

                final posterPath = movie['poster_path'] as String?;
                final backdropPath = movie['backdrop_path'] as String?;
                final title = movie['title'] as String;
                final overview = movie['overview'] as String?;
                final voteAverage = movie['vote_average']?.toString() ?? '0.0';
                final releaseDate = movie['release_date'] as String?;
                final videoId = movie['video_id'] as String?;

                final posterUrl = posterPath != null
                    ? 'https://image.tmdb.org/t/p/w500$posterPath'
                    : 'https://via.placeholder.com/500x750.png?text=No+Poster';
                final backdropUrl = backdropPath != null
                    ? 'https://image.tmdb.org/t/p/w500$backdropPath'
                    : 'https://via.placeholder.com/500x281.png?text=No+Image';

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 8),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(),
                    color: Colors.black26,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Description(
                              name: title,
                              bannerurl: backdropUrl,
                              posterurl: posterUrl,
                              description: overview ?? 'No description available',
                              vote: voteAverage,
                              launchon: releaseDate ?? 'Release date unknown',
                              id: videoId ?? '',
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            posterUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200,
                              color: Colors.grey[900],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white54,
                                size: 50,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ModifiedText(
                                    text: title,
                                    color: Colors.white,
                                    size: 14,
                                    maxLines: 2,
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      ModifiedText(
                                        text: voteAverage,
                                        color: Colors.white70,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
