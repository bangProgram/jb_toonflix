import 'package:flutter/material.dart';
import 'package:jb_toonflix/models/webtoon_detail_model.dart';
import 'package:jb_toonflix/models/webtoon_episode_model.dart';
import 'package:jb_toonflix/service/api_service.dart';
import 'package:jb_toonflix/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, id, thumb;

  const DetailScreen({
    super.key,
    required this.title,
    required this.id,
    required this.thumb,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoonDetail;
  late Future<List<WebtoonEpisodeModel>> webtoonEpisodes;
  late SharedPreferences prefs;
  List<String> favorList = [];
  bool isFavor = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webtoonDetail = ApiService.getWebtoonDetail(widget.id);
    webtoonEpisodes = ApiService.getWebtoonEpisode(widget.id);
    getFavorList();
  }

  void getFavorList() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('favorList') != null) {
      favorList = prefs.getStringList('favorList')!;
      if (prefs.getStringList('favorList')!.contains(widget.id)) {
        isFavor = true;
        setState(() {});
      }
    }
  }

  void setFavorList() async {
    if (isFavor) {
      favorList.remove(widget.id);
      await prefs.setStringList('favorList', favorList);
    } else {
      favorList.add(widget.id);
      await prefs.setStringList('favorList', favorList);
    }
    isFavor = !isFavor;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: setFavorList,
            icon: isFavor
                ? const Icon(
                    Icons.favorite,
                  )
                : const Icon(
                    Icons.favorite_outline,
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Hero(
                tag: widget.id,
                child: Container(
                  width: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(10, 10),
                        ),
                      ]),
                  child: Image.network(
                    widget.thumb,
                    headers: const {
                      "User-Agent":
                          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: webtoonDetail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var webtoonDetail = snapshot.data!;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green.withOpacity(0.2),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Text(
                          webtoonDetail.title,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              webtoonDetail.age,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                              height: 50,
                            ),
                            Text(webtoonDetail.genre),
                          ],
                        ),
                        Text(webtoonDetail.about),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: webtoonEpisodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var episodes = snapshot.data!;
                  return Container(
                    child: Column(
                      children: [
                        for (var episode in episodes)
                          EpisodeWidget(
                            episode: episode,
                            webtoonId: widget.id,
                          ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
