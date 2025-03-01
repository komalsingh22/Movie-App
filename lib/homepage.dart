import 'package:flutter/material.dart';
import 'package:movie_app/widget/tv.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movie_app/widget/constants/constant.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widget/trending.dart';
import 'package:movie_app/widget/toprated.dart';
import 'package:movie_app/widget/searchbar.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingmovies = [];
  List topratedmovies = []; 
  List tv = [];

  @override
  void initState() {
    loadmovies();
    super.initState();
  }

  Future<void> loadmovies() async {
    TMDB tmdbWithCustomLogo = TMDB(ApiKeys(apikey, readaccesstoken),
        logConfig: ConfigLogger(
          showLogs: true,
          showErrorLogs: true,
        ));
    Map trendingresult = await tmdbWithCustomLogo.v3.trending.getTrending();
    Map topratedresult = await tmdbWithCustomLogo.v3.movies.getTopRated();
    Map tyresults = await tmdbWithCustomLogo.v3.tv.getPopular();

    // Fetch video data for trending movies
    for (var movie in trendingresult['results']) {
      try {
        final videos = await tmdbWithCustomLogo.v3.movies.getVideos(movie['id']);
        final trailers = videos['results'].where((v) => v['type'] == 'Trailer' && v['site'] == 'YouTube');
        movie['video_id'] = trailers.isNotEmpty ? trailers.first['key'] : '';
      } catch (e) {
        movie['video_id'] = '';
      }
    }

    // Fetch video data for top-rated movies
    for (var movie in topratedresult['results']) {
      try {
        final videos = await tmdbWithCustomLogo.v3.movies.getVideos(movie['id']);
        final trailers = videos['results'].where((v) => v['type'] == 'Trailer' && v['site'] == 'YouTube');
        movie['video_id'] = trailers.isNotEmpty ? trailers.first['key'] : '';
      } catch (e) {
        movie['video_id'] = '';
      }
    }

    // Fetch video data for TV shows
    for (var show in tyresults['results']) {
      try {
        final videos = await tmdbWithCustomLogo.v3.tv.getVideos(show['id']);
        final trailers = videos['results'].where((v) => v['type'] == 'Trailer' && v['site'] == 'YouTube');
        show['video_id'] = trailers.isNotEmpty ? trailers.first['key'] : '';
      } catch (e) {
        show['video_id'] = '';
      }
    }

    setState(() {
      trendingmovies = trendingresult['results'];
      topratedmovies = topratedresult['results'];
      tv = tyresults['results'];
    });

    print(trendingmovies);
    //print(topratedmovies);
     //print(tv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const ModifiedText(
          text: '🎬 Movie App',
          color: Colors.white,
          size: 24,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadmovies,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          TV(tv: tv),
          const SizedBox(height: 20),
          Toprated(toprated: topratedmovies),
          const SizedBox(height: 20),
          TrendingMovies(trending: trendingmovies),
        ],
      ),
    );
  }
}
