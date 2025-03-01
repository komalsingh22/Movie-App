import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widget/description.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movie_app/widget/constants/constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final tmdb = TMDB(
        ApiKeys(apikey, readaccesstoken),
        logConfig: ConfigLogger(
          showLogs: true,
          showErrorLogs: true,
        ),
      );

      final results = await tmdb.v3.search.queryMulti(query);
      
      // Process results to add video IDs
      for (var item in results['results']) {
        try {
          if (item['media_type'] == 'movie') {
            final videos = await tmdb.v3.movies.getVideos(item['id']);
            final trailers = videos['results'].where(
              (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
            );
            item['video_id'] = trailers.isNotEmpty ? trailers.first['key'] : '';
          } else if (item['media_type'] == 'tv') {
            final videos = await tmdb.v3.tv.getVideos(item['id']);
            final trailers = videos['results'].where(
              (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
            );
            item['video_id'] = trailers.isNotEmpty ? trailers.first['key'] : '';
          }
        } catch (e) {
          item['video_id'] = '';
        }
      }

      setState(() {
        searchResults = results['results'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies, TV shows...',
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white54),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  searchResults = [];
                });
              },
            ),
          ),
          onChanged: (value) {
            searchMovies(value);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.white54,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      ModifiedText(
                        text: _searchController.text.isEmpty
                            ? 'Search for movies and TV shows'
                            : 'No results found',
                        color: Colors.white54,
                        size: 16,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchResults[index];
                    final isMovie = result['media_type'] == 'movie';
                    final title =
                        isMovie ? result['title'] : result['name'] ?? 'Unknown';
                    final releaseDate = isMovie
                        ? result['release_date']
                        : result['first_air_date'] ?? 'Unknown';

                    return Card(
                      color: Colors.black26,
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                name: title,
                                description: result['overview'] ?? '',
                                bannerurl: result['backdrop_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500${result['backdrop_path']}'
                                    : 'https://via.placeholder.com/500x281',
                                posterurl: result['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
                                    : 'https://via.placeholder.com/500x750',
                                vote: result['vote_average'].toString(),
                                launchon: releaseDate,
                                id: result['video_id'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                              child: Image.network(
                                result['poster_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w500${result['poster_path']}'
                                    : 'https://via.placeholder.com/100x150',
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: 100,
                                    color: Colors.grey[900],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white54,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ModifiedText(
                                      text: title,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          isMovie
                                              ? Icons.movie
                                              : Icons.tv,
                                          color: Colors.white54,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        ModifiedText(
                                          text: isMovie ? 'Movie' : 'TV Show',
                                          color: Colors.white54,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        ModifiedText(
                                          text: result['vote_average'].toString(),
                                          color: Colors.white54,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ModifiedText(
                                      text: result['overview'] ?? '',
                                      color: Colors.white54,
                                      size: 14,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
} 