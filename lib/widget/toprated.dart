import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widget/description.dart';

class Toprated extends StatelessWidget {
  const Toprated({super.key, required this.toprated});
  final List toprated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(
              text: 'Top Rated Movies ', color: Colors.white, size: 26),
          const SizedBox(height: 10),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: toprated.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: toprated[index]['title'],
                          bannerurl:
                              'https://image.tmdb.org/t/p/w500${toprated[index]['backdrop_path']}',
                          posterurl:
                              'https://image.tmdb.org/t/p/w500${toprated[index]['poster_path']}',
                          description: toprated[index]['overview'],
                          vote: toprated[index]['vote_average'].toString(),
                          launchon: toprated[index]['release_date'],
                          id: toprated[index]['video_id'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: toprated[index]['title'] != null
                      ? SizedBox(
                          width: 140,
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${toprated[index]['poster_path']}',
                                      ),
                                    ),
                                  ),
                                ),
                                ModifiedText(
                                  text: toprated[index]['title'] ?? 'loading',
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
