class WebtoonModel {
  final String title, id, thumb;
  String? test;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        thumb = json['thumb'];
}
