import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/annotation.dart';
import 'package:simple_http_gen/src/parser/delete_parser.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:test/test.dart';
import 'package:analyzer/dart/element/element.dart';

import 'util.dart';

class DeleteParserTest {
  final LibraryReader libraryReader;
  final MethodParser deleteParser = DeleteParser();

  DeleteParserTest(this.libraryReader);

  void test() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'DELETEAnnotationTest');

    MethodElement method = classElement.methods[0];
    String baseUrl = TypeChecker.fromRuntime(Base)
        .annotationsOfExact(classElement)
        .first
        .getField('baseUrl')!
        .toStringValue()!;

    String result = deleteParser.parse(method, baseUrl);
    String expected = '''
    String endPoint = '/api/v1/users/\$path';
    Map<String, dynamic> queryParam = {};
    String body = jsonEncode(body.toJson());
    Map<String, String> headerParam = {};
    Uri uri = Uri.https('example.org', endPoint, queryParam);
    http.Response response = await http.delete(uri, headers: headerParam, body: body);
    
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error('\${response.statusCode}: \${response.body}');
    }
    
    return response.body;
''';

    expect(result, expected);
  }
}

Future<void> main() async {
  LibraryReader libraryReader = await createLibrayReader();
  DeleteParserTest deleteParserTest = DeleteParserTest(libraryReader);

  test('delete parsing test', () => deleteParserTest.test());
}
