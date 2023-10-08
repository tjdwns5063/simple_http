import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/annotation.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:simple_http_gen/src/parser/uri_parser.dart';
import 'package:test/test.dart';

import 'util.dart';

class UriParserTest extends MethodParser with UriParser {
  LibraryReader libraryReader;

  UriParserTest(this.libraryReader);

  @override
  String parse(Element method, String baseUrl) {
    return parseUri(baseUrl);
  }

  void testHttpUri() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'HttpUriParseTest');

    TypeChecker typeChecker = TypeChecker.fromRuntime(Base);

    String baseUrl = typeChecker
        .firstAnnotationOfExact(classElement)!
        .getField('baseUrl')!
        .toStringValue()!;

    final String result = parse(classElement.methods.first, baseUrl);
    expect(result, 'Uri.http(\'example.org\', endPoint, queryParam)');
  }

  void testHttpsUri() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'HttpsUriParseTest');

    TypeChecker typeChecker = TypeChecker.fromRuntime(Base);

    String baseUrl = typeChecker
        .firstAnnotationOfExact(classElement)!
        .getField('baseUrl')!
        .toStringValue()!;

    final String result = parse(classElement.methods.first, baseUrl);
    expect(result, 'Uri.https(\'example.org\', endPoint, queryParam)');
  }

  void testInvalidSchemeUri() {
    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'InvalidUriParseTest');

    TypeChecker typeChecker = TypeChecker.fromRuntime(Base);

    String baseUrl = typeChecker
        .firstAnnotationOfExact(classElement)!
        .getField('baseUrl')!
        .toStringValue()!;

    try {
      parse(classElement.methods.first, baseUrl);
    } catch (err) {
      expect(err, isArgumentError);
    }
  }
}

Future<void> main() async {
  UriParserTest uriParserTest = UriParserTest(await createLibrayReader());
  group('Uri Parse Test By Valid Parameter', () {
    test('when uri scheme is http test', () => uriParserTest.testHttpUri());
    test('when uri scheme is https test', () => uriParserTest.testHttpsUri());
  });
  group('Uri Parse Test By Invalid Parameter', () {
    test('when uri scheme is invalid test',
        () => uriParserTest.testInvalidSchemeUri());
  });
}
