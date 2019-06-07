import 'package:network_tests/network_layer/network_mappers.dart';

class PostList extends ListMapable {
  List<PostResponse> posts;

  @override
  Mapable fromJsonList(List json) {
    posts = json.map((i) => PostResponse.fromJson(i)).toList();
    return this;
  }
}

class PostResponse {
  String userId;
  int id;
  String title;
  String body;

  PostResponse({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return new PostResponse(
      userId: json['userId'].toString(),
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}