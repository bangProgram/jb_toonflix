import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jb_toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodayToons() async {
    List<WebtoonModel> webtoonInstances = [];
    Uri url = Uri.parse('$baseUrl/$today');
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
}
