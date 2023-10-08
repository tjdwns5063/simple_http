import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/parser/header_parser.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:test/test.dart';

import 'util.dart';

class HeaderParserTest extends MethodParser with HeaderParser {
  HeaderParserTest(this.libraryReader);

  final LibraryReader libraryReader;

  @override
  String parse(Element method, String? baseUrl) {
    return parseHeader(method).toString();
  }

  void testValidOneParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'HeaderAnnotationTest');

    String result = parse(classElement.methods[0], 'http://example.org');

    expect(result, '{\'Authorization\': token}');
  }

  void testValidMultiParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'HeaderAnnotationTest');

    String result = parse(classElement.methods[1], 'http://example.org');

    expect(
        result, '{\'Authorization\': token, \'Content-Type\': content_type}');
  }
}

Future<void> main() async {
  HeaderParserTest headerParserTest =
      HeaderParserTest(await createLibrayReader());

  group('Test Header Annotation By Valid Parameter', () {
    test('valid one parameter test',
        () => headerParserTest.testValidOneParameter());
    test('valid mutliple parameter test',
        () => headerParserTest.testValidMultiParameter());
  });
}
