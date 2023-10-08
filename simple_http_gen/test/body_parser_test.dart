import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/parser/body_parser.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:test/test.dart';
import 'package:analyzer/dart/element/element.dart';

import 'util.dart';

class BodyParserTest extends MethodParser with BodyParser {
  LibraryReader libraryReader;

  BodyParserTest(this.libraryReader);

  void testOneValidParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'BodyAnnotationTest');

    String result = parse(classElement.methods[0], 'http://example.org');

    expect(result, 'jsonEncode(user.toJson())');
  }

  void testMultiParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'BodyAnnotationTest');

    try {
      parse(classElement.methods[1], 'http://example.org');
    } catch (err) {
      expect(err, isArgumentError);
    }
  }

  void testNoParameter() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'BodyAnnotationTest');

    String result = parse(classElement.methods[2], 'http://example.org');

    expect(result, '\'{}\'');
  }

  @override
  String parse(Element method, String baseUrl) {
    return parseBody(method);
  }
}

Future<void> main() async {
  BodyParserTest bodyParserTest = BodyParserTest(await createLibrayReader());

  group('Test Body Annotation Parse Test', () {
    test('when one valid parameter test',
        () => bodyParserTest.testOneValidParameter());
    test('when muti valid parameter test',
        () => bodyParserTest.testMultiParameter());
    test('when no parameter test', () => bodyParserTest.testNoParameter());
  });
}
