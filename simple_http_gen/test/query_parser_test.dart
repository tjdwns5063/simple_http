import 'dart:core';

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:simple_http_gen/src/parser/http_method_parser.dart';
import 'package:simple_http_gen/src/parser/query_parser.dart';
import 'package:test/test.dart';

import 'util.dart';

class QueryParserTest extends MethodParser with QueryParser {
  @override
  String parse(Element method, String? baseUrl) {
    return parseQuery(method).toString();
  }

  Future<void> testOneValidParameter() async {
    LibraryReader libraryReader = await createLibrayReader();

    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'QueryAnnotationTest');

    String ret = parse(classElement.methods.first, 'http://example.org');

    expect(ret, '''{'name': name}''');
  }

  Future<void> testMultiValidParameter() async {
    LibraryReader libraryReader = await createLibrayReader();

    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'QueryAnnotationTest');

    String ret = parse(classElement.methods[1], 'http://example.org');

    expect(
      ret,
      '''{'name': name, 'time': time}''',
    );
  }

  Future<void> testNullValidParameter() async {
    LibraryReader libraryReader = await createLibrayReader();

    ClassElement classElement = libraryReader.classes
        .firstWhere((element) => element.name == 'QueryAnnotationTest');

    String ret = parse(classElement.methods[2], 'http://example.org');

    expect(
      ret,
      '''{'abc': abc}''',
    );
  }
}

void main() {
  QueryParserTest queryParserTest = QueryParserTest();

  group('Query Annotation Parse Test By Valid Parameter', () {
    test('one query parameter test',
        () => queryParserTest.testOneValidParameter());
    test('mutil query parameter test',
        () => queryParserTest.testMultiValidParameter());

    test('if query parameter is null test',
        () => queryParserTest.testNullValidParameter());
  });
}
