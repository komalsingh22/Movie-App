import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widget/description.dart';
class TV extends StatelessWidget {
  const TV({super.key, required this.tv});
  final List tv;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModifiedText(text: 'Popular TV Shows', color: Colors.white, size: 26),
          const SizedBox(height: 10),
          SizedBox(
            height: 250, // Increase height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tv.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Description(
                      name: tv[index]['original_name'],
                      bannerurl: 'https://image.tmdb.org/t/p/w500${tv[index]["backdrop_path"]}',
                      posterurl: 'https://image.tmdb.org/t/p/w500${tv[index]["poster_path"]}',
                      description: tv[index]['overview'],
                      vote: tv[index]['vote_average'].toString(),
                      launchon: tv[index]['first_air_date'],
                      id: tv[index]['video_id'] ?? '',
                    )));  
                  },
                  child: tv[index]['original_name'] != null ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: screenWidth - 30, // Full width with margin
                    child: Column(
                      children: [
                        // Banner image
                        Container(
                          height: 180, // Increase height
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${tv[index]["backdrop_path"]}',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // TV show title
                        ModifiedText(
                          text: tv[index]['original_name'] ?? 'Loading...',
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ) : Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
