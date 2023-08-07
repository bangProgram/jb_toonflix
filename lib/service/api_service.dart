import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jb_toonflix/models/webtoon_detail_model.dart';
import 'package:jb_toonflix/models/webtoon_episode_model.dart';
import 'package:jb_toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl = "webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodayToons() async {
    List<WebtoonModel> webtoonInstances = [];
    Uri url = Uri.https(baseUrl, today);
    final reponse = await http.get(url);
    if (reponse.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(reponse.body);
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      // final json = jsonDecode(reponse.body);
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getWebtoonDetail(String id) async {
    Uri url = Uri.https(baseUrl, id);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var webtoonDetail = jsonDecode(response.body);
      print(webtoonDetail);
      return WebtoonDetailModel.fromJson(webtoonDetail);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getWebtoonEpisode(String id) async {
    List<WebtoonEpisodeModel> webtoonEpisodeInstance = [];
    Uri url = Uri.https(baseUrl, '$id/episodes');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        webtoonEpisodeInstance.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return webtoonEpisodeInstance;
    }
    throw Exception('Failed to load episodes');
  }
}
