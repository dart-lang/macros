import 'package:dart_model/dart_model.dart';
import 'package:test/test.dart';

void main() {
  void setupTypeHierarchyModel() {
    final hierarchy = TypeHierarchy();

    void registerCoreType(String name, [String? extending]) {
      hierarchy.named['dart:core#$name'] = TypeHierarchyEntry(
        self: NamedTypeDesc(
          name: QualifiedName(name: name, uri: 'dart:core'),
          instantiation: [],
        ),
        typeParameters: [],
        supertypes: [
          if (extending != null)
            NamedTypeDesc(
              name: QualifiedName(name: extending, uri: 'dart:core'),
              instantiation: [],
            ),
        ],
      );
    }

    registerCoreType('Object');
    registerCoreType('String', 'Object');
    MacroScope.current.addModel(Model(types: hierarchy));
  }

  StaticTypeDesc coreType(String name) {
    return StaticTypeDesc.namedTypeDesc(
      NamedTypeDesc(
        name: QualifiedName(name: name, uri: 'dart:core'),
        instantiation: [],
      ),
    );
  }

  test('isSubtype uses resolved model', () {
    Scope.macro.run(() {
      setupTypeHierarchyModel();

      final object = StaticType(coreType('Object'));
      final string = StaticType(coreType('String'));

      expect(string.isSubtypeOf(object), isTrue);
      expect(object.isSubtypeOf(string), isFalse);
    });
  });

  test('isEqualTo uses resolved model', () {
    Scope.macro.run(() {
      setupTypeHierarchyModel();

      final object = StaticType(coreType('Object'));
      final string = StaticType(coreType('String'));

      expect(string.isEqualTo(string), isTrue);
      expect(object.isEqualTo(string), isFalse);
    });
  });
}
