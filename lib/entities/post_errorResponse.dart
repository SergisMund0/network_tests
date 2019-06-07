import 'package:network_tests/network_layer/network_mappers.dart';

class ErrorResponse implements ErrorMapable, BaseMapable {
  @override
  String description;

  @override
  String errorCode;

  @override
  Mapable fromJson(Map<String, dynamic> json) {
    this.errorCode = json['error_code'];
    this.description = json['description'];

    return this;
  }
}