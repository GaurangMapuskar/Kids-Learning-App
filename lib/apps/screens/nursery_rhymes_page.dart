import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NurseryRhymesPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Twinkle Twinkle Little Star',
      'videoId': 'https://www.youtube.com/watch?v=yCjJyiqpAuU',
    },
    {
      'title': 'Old MacDonald Had a Farm',
      'videoId': 'https://www.youtube.com/watch?v=yCjJyiqpAuU',
    },
    // Add more nursery rhyme videos here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nursery Rhymes'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return ListTile(
            title: Text(video['title']!),
            onTap: () {
              _playVideo(context, video['videoId']!);
            },
          );
        },
      ),
    );
  }

  void _playVideo(BuildContext context, String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoId: videoId),
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;

  VideoPlayerScreen({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          progressColors: ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
