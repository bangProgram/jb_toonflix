import 'package:flutter/material.dart';
import 'package:jb_toonflix/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EpisodeWidget extends StatelessWidget {
  const EpisodeWidget({
    super.key,
    required this.webtoonId,
    required this.episode,
  });

  final String webtoonId;
  final WebtoonEpisodeModel episode;

  void goWebtoonPage() {
    launchUrlString(
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goWebtoonPage,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              episode.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                // color: Colors.white,
              ),
            ),
            const Icon(
              Icons.chevron_right_outlined,
              // color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
