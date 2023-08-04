import 'package:flutter/material.dart';
import 'package:jb_toonflix/models/webtoon_model.dart';
import 'package:jb_toonflix/service/api_service.dart';
import 'package:jb_toonflix/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodayToons();

  @override
  Widget build(BuildContext context) {
    print(webtoons);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오늘의 웹툰's",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: makeList(snapshot),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var webtoon = snapshot.data![index];
          return WebtoonWidget(
            title: webtoon.title,
            id: webtoon.id,
            thumb: webtoon.thumb,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 20,
          );
        },
        itemCount: snapshot.data!.length);
  }
}
