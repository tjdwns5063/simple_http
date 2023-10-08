import 'package:code_builder/code_builder.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

mixin ParameterCreator {
  List<Parameter> createRequiredParameter(MethodElement element) {
    return element.parameters
        .where((element) => element.isRequiredPositional)
        .map((paramElem) => Parameter(
              (builder) => builder
                ..name = paramElem.name
                ..type = Reference(paramElem.type.getDisplayString(
                    withNullability: paramElem.type.nullabilitySuffix !=
                        NullabilitySuffix.none)),
            ))
        .toList();
  }

  List<Parameter> createOptionalParameter(MethodElement element) {
    return element.parameters
        .where((element) => element.isOptional)
        .map((paramElem) => Parameter((builder) {
              builder
                ..named = paramElem.isNamed
                ..name = paramElem.name
                ..type = Reference(paramElem.type.getDisplayString(
                    withNullability: paramElem.type.nullabilitySuffix !=
                        NullabilitySuffix.none));
              if (paramElem.defaultValueCode != null) {
                builder.defaultTo = Code(paramElem.defaultValueCode!);
              }
            }))
        .toList();
  }
}
