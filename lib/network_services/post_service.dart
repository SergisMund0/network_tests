import 'package:network_tests/entities/post_request.dart';
import 'package:network_tests/network_layer/http_request.dart';

class PostService extends HttpRequestProtocol {
  final PostRequest postRequest;

  PostService(this.postRequest);

  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  @override
  ContentEncoding get contentEncoding => ContentEncoding.url;

  @override
  Map<String, String> get headers => {
        "content-type": "application/x-www-form-urlencoded",
        "accept": "application/json",
      };

  @override
  HttpMethod get method => HttpMethod.GET;

  @override
  Map<String, dynamic> get parameters => this.postRequest.toJson();

  @override
  String get path => '/posts';
}