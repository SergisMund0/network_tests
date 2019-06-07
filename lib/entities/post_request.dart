import 'package:network_tests/network_layer/network_mappers.dart';

class PostRequest extends RequestMapable {
  final String userId;

  PostRequest(this.userId);

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
      };
}