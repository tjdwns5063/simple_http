import 'dart:io';

import 'package:build_test/build_test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

Future<LibraryReader> createLibrayReader() async {
  final String fileName = 'test_library.dart';
  final String path = 'test/src/';
  final String content = File('$path/$fileName').readAsStringSync();

  String assetIdForFile(String fileName) => '__test__|lib/$fileName';

  final String targetFileId = assetIdForFile('test_library.dart');

  LibraryElement library = await resolveSource(
      content,
      (resolver) async =>
          await resolver.libraryFor(AssetId.parse(targetFileId)),
      inputId: AssetId.parse(targetFileId));

  return LibraryReader(library);
}
