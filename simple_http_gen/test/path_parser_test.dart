import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:simple_http_gen/src/parser/path_parser.dart';
import 'package:test/test.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:simple_http_annotation/simple_http_annotation.dart';

import 'util.dart';

class PathParserTest extends MethodParser with PathParser {
  LibraryReader libraryReader;
  TypeChecker typeChecker;

  PathParserTest(this.libraryReader, this.typeChecker);

  void testOneValidParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'PathAnnotationTest');

    String result = parse(classElement.methods[0], 'http://example.org');

    expect(result, '/api/v1/hello/\$uid');
  }

  void testMultiValidParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'PathAnnotationTest');

    String result = parse(classElement.methods[1], 'http://example.org');

    expect(result, '/api/v1/hello/\$uid/\$userName');
  }

  @override
  String parse(Element method, String baseUrl) {
    return parsePath(method, TypeChecker.fromRuntime(GET));
  }
}

Future<void> main() async {
  PathParserTest pathParserTest =
      PathParserTest(await createLibrayReader(), TypeChecker.fromRuntime(Path));

  group('Path Annotation Test By Valid Parameter', () {
    test('one path parameter test',
        () => pathParserTest.testOneValidParameter());
    test('mutil path parameter test',
        () => pathParserTest.testMultiValidParameter());
  });
}
