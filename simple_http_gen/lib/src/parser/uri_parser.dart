import 'package:simple_http_gen/src/parser/http_method_parser.dart';

mixin UriParser on MethodParser {
  String parseUri(String baseUrl) {
    Uri uri = Uri.parse(baseUrl);

    return switch (uri.scheme) {
      'http' => 'Uri.http(\'${uri.host}\', endPoint, queryParam)',
      'https' => 'Uri.https(\'${uri.host}\', endPoint, queryParam)',
      _ => throw ArgumentError('Invalid Host in Url', "invalid_host")
    };
  }
}
