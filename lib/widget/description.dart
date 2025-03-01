import 'package:flutter/material.dart';
import 'package:movie_app/utils/text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Description extends StatefulWidget {
  const Description({
    super.key,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
    required this.vote,
    required this.launchon,
    required this.id,
  });
  final String name;
  final String description;
  final String bannerurl;
  final String posterurl;
  final String vote;
  final String launchon;
  final String id;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  late YoutubePlayerController _controller;
  bool _isVideoAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.id.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: widget.id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
      setState(() {
        _isVideoAvailable = true;
      });
    }
  }

  @override
  void dispose() {
    if (_isVideoAvailable) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _isVideoAvailable
                  ? YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.red,
                        handleColor: Colors.redAccent,
                      ),
                    )
                  : Image.network(
                      widget.bannerurl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.posterurl,
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title and Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ModifiedText(
                              text: widget.name,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                ModifiedText(
                                  text: widget.vote,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                ModifiedText(
                                  text: widget.launchon,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                              ],
                            ),
                            if (_isVideoAvailable) ...[
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  // Scroll to top to show video
                                },
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Watch Trailer'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ModifiedText(
                    text: 'Overview',
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  ModifiedText(
                    text: widget.description,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 