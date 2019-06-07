import 'package:http/http.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:network_tests/dart_extensions/enumeration.dart';

/// The HTTP method of the request.
class HttpMethod extends Enum<String> {
  const HttpMethod(String val) : super(val);

  static const HttpMethod GET = const HttpMethod('GET');
  static const HttpMethod POST = const HttpMethod('POST');
  static const HttpMethod PUT = const HttpMethod('PUT');
  static const HttpMethod DELETE = const HttpMethod('DELETE');
}

/// The request's encoding type.
enum ContentEncoding { url, json }

/// 'HttpRequestProtocol' encapsulates the entire data necessary to create our requests.
/// It will be helper to create our Request object of 'http.dart' package.
abstract class HttpRequestProtocol {
  String get baseUrl;
  String get path;
  HttpMethod get method;
  Map<String, String> get headers;
  Map<String, dynamic> get parameters;
  ContentEncoding get contentEncoding;

  /// Do not override this getter. Whenever the method's request is GET,
  /// the layer will concatenate the parameters into the query.
  String get queryParameters {
    if (method == HttpMethod.GET) {
      final jsonString = Uri(queryParameters: parameters);
      return '?${jsonString.query}';
    }

    return '';
  }
}

/// 'HttpRequest' receives a 'HttpRequestProtocol' object with all the request's information.
class HttpRequest extends Request {
  final HttpRequestProtocol service;

  HttpRequest(this.service)
      : super(
            service.method.value,
            Uri.parse(
                '${service.baseUrl}${service.path}${service.queryParameters}'));

  @override
  Map<String, String> get headers => this.service.headers;

  @override
  String get body => json.encode(this.service.parameters);

  @override
  Uint8List get bodyBytes {
    if (service.contentEncoding == ContentEncoding.url) {
      final queryParameters = Uri(queryParameters: service.parameters);
      List<int> bodyBytes = utf8.encode(queryParameters.query);

      return bodyBytes;
    } else {
      final encodedBody = Utf8Codec().encode(body);
      return Uint8List.fromList(encodedBody);
    }
  }

  @override
  MediaType get _contentType {
    var contentType = headers['content-type'];
    if (contentType == null) return null;
    return new MediaType.parse(contentType);
  }
}