// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'generate_dart_model.dart';

final schemas = Schemas([
  Schema(
      schemaPath: 'dart_model.schema.json',
      codePackage: 'dart_model',
      codePath: 'src/dart_model.g.dart',
      rootTypes: [
        'Model',
      ],
      declarations: [
        Declaration.clazz(
          'Augmentation',
          'An augmentation to Dart code. '
              'TODO(davidmorgan): this is a placeholder.',
          [
            Field('code', 'String', 'Augmentation code.'),
          ],
        ),
        Declaration.nullTypedef('DynamicTypeDesc',
            'The type-hierarchy representation of the type `dynamic`.'),
        Declaration.clazz('FunctionTypeDesc',
            'A static type representation for function types.', [
          Field('returnType', 'StaticTypeDesc',
              'The return type of this function type.'),
          Field('typeParameters', 'List<StaticTypeParameterDesc>',
              'Static type parameters introduced by this function type.'),
          Field('requiredPositionalParameters', 'List<StaticTypeDesc>', ''),
          Field('optionalPositionalParameters', 'List<StaticTypeDesc>', ''),
          Field('namedParameters', 'List<NamedFunctionTypeParameter>', ''),
        ]),
        Declaration.clazz('MetadataAnnotation', 'A metadata annotation.', [
          Field('type', 'QualifiedName', 'The type of the annotation.'),
        ]),
        Declaration.clazz(
          'Interface',
          'An interface.',
          [
            Field('metadataAnnotations', 'List<MetadataAnnotation>',
                'The metadata annotations attached to this interface.'),
            Field('members', 'Map<Member>', 'Map of members by name.'),
            Field(
                'thisType',
                'NamedTypeDesc',
                'The type of the expression `this` when used in this '
                    'interface.'),
            Field('properties', 'Properties',
                'The properties of this interface.'),
          ],
        ),
        Declaration.clazz('Library', 'Library.', [
          Field('scopes', 'Map<Interface>', 'Scopes by name.'),
        ]),
        Declaration.clazz('Member', 'Member of a scope.', [
          Field('properties', 'Properties', 'The properties of this member.'),
        ]),
        Declaration.clazz(
            'Model', 'Partial model of a corpus of Dart source code.', [
          Field('uris', 'Map<Library>', 'Libraries by URI.'),
          Field(
              'types', 'TypeHierarchy', 'The resolved static type hierarchy.'),
        ]),
        Declaration.clazz('NamedFunctionTypeParameter',
            'A resolved named parameter as part of a [FunctionTypeDesc].', [
          Field('name', 'String', ''),
          Field('required', 'bool', ''),
          Field('type', 'StaticTypeDesc', ''),
        ]),
        Declaration.clazz(
            'NamedRecordField',
            'A named field in a [RecordTypeDesc], consisting of the field name '
                'and the associated type.',
            [
              Field('name', 'String', ''),
              Field('type', 'StaticTypeDesc', ''),
            ]),
        Declaration.clazz('NamedTypeDesc', 'A resolved static type.', [
          Field('name', 'QualifiedName', ''),
          Field('instantiation', 'List<StaticTypeDesc>', ''),
        ]),
        Declaration.nullTypedef(
            'NeverTypeDesc', 'Representation of the bottom type [Never].'),
        Declaration.clazz(
          'NullableTypeDesc',
          'A Dart type of the form `T?` for an inner type `T`.',
          [Field('inner', 'StaticTypeDesc', 'The type T.')],
        ),
        Declaration.clazz('Properties', 'Set of boolean properties.', [
          Field('isAbstract', 'bool',
              'Whether the entity is abstract, meaning it has no definition.'),
          Field('isClass', 'bool', 'Whether the entity is a class.'),
          Field('isGetter', 'bool', 'Whether the entity is a getter.'),
          Field('isField', 'bool', 'Whether the entity is a field.'),
          Field('isMethod', 'bool', 'Whether the entity is a method.'),
          Field('isStatic', 'bool', 'Whether the entity is static.'),
        ]),
        Declaration.stringTypedef(
            'QualifiedName', 'A URI combined with a name.'),
        Declaration.clazz(
            'Query',
            'Query about a corpus of Dart source code. '
                'TODO(davidmorgan): this queries about a single class, expand '
                'to a union type for different types of queries.',
            [
              Field('target', 'QualifiedName', 'The class to query about.'),
            ]),
        Declaration.clazz(
            'RecordTypeDesc', 'A resolved record type in the type hierarchy.', [
          Field('positional', 'List<StaticTypeDesc>', ''),
          Field('named', 'List<NamedRecordField>', '')
        ]),
        Declaration.union(
            'StaticTypeDesc',
            'A partially-resolved description of a type as it appears in '
                "Dart's type hierarchy.",
            [
              'DynamicTypeDesc',
              'FunctionTypeDesc',
              'NamedTypeDesc',
              'NeverTypeDesc',
              'NullableTypeDesc',
              'RecordTypeDesc',
              'TypeParameterTypeDesc',
              'VoidTypeDesc',
            ],
            []),
        Declaration.clazz('StaticTypeParameterDesc',
            'A resolved type parameter introduced by a [FunctionTypeDesc].', [
          Field('identifier', 'int', ''),
          Field('bound', 'StaticTypeDesc', '')
        ]),
        Declaration.clazz(
            'TypeHierarchy',
            "View of a subset of a Dart program's type hierarchy as part of a "
                'queried model.',
            [
              Field(
                  'named',
                  'Map<TypeHierarchyEntry>',
                  'Map of qualified interface names to their resolved named '
                      'type.')
            ]),
        Declaration.clazz(
            'TypeHierarchyEntry',
            "Entry of an interface in Dart's type hierarchy, along with "
                'supertypes.',
            [
              Field(
                  'typeParameters',
                  'List<StaticTypeParameterDesc>',
                  'Type parameters defined on this interface-defining '
                      'element.'),
              Field('self', 'NamedTypeDesc',
                  'The named static type represented by this entry.'),
              Field('supertypes', 'List<NamedTypeDesc>',
                  'All direct supertypes of this type.'),
            ]),
        Declaration.clazz('TypeParameterTypeDesc',
            'A type formed by a reference to a type parameter.', [
          Field('parameterId', 'int', ''),
        ]),
        Declaration.nullTypedef('VoidTypeDesc',
            'The type-hierarchy representation of the type `void`.'),
      ]),
  Schema(
      schemaPath: 'macro_service.schema.json',
      codePackage: 'macro_service',
      codePath: 'src/macro_service.g.dart',
      rootTypes: [
        'HostRequest',
        'MacroRequest',
        'Response',
      ],
      declarations: [
        Declaration.clazz(
            'AugmentRequest', 'A request to a macro to augment some code.', [
          Field('phase', 'int', 'Which phase to run: 1, 2 or 3.'),
          Field(
              'target',
              'QualifiedName',
              'The class to augment. '
                  'TODO(davidmorgan): expand to more types of target.'),
        ]),
        Declaration.clazz(
            'AugmentResponse',
            "Macro's response to an [AugmentRequest]: the resulting "
                'augmentations.',
            [
              Field(
                  'augmentations', 'List<Augmentation>', 'The augmentations.'),
            ]),
        Declaration.clazz('ErrorResponse', 'Request could not be handled.', [
          Field('error', 'String', 'The error.'),
        ]),
        Declaration.clazz(
            'HostEndpoint',
            'A macro host server endpoint. TODO(davidmorgan): this should be a '
                'oneOf supporting different types of connection. '
                "TODO(davidmorgan): it's not clear if this belongs in this "
                'package! But, where else?',
            [
              Field('port', 'int', 'TCP port to connect to.'),
            ]),
        Declaration.union('HostRequest', 'A request sent from host to macro.', [
          'AugmentRequest'
        ], [
          Field('id', 'int',
              'The id of this request, must be returned in responses.',
              required: true),
        ]),
        Declaration.clazz('MacroDescription',
            'Information about a macro that the macro provides to the host.', [
          Field('runsInPhases', 'List<int>',
              'Phases that the macro runs in: 1, 2 and/or 3.'),
        ]),
        Declaration.clazz(
          'MacroStartedRequest',
          'Informs the host that a macro has started.',
          [
            Field('macroDescription', 'MacroDescription',
                'The macro description.'),
          ],
        ),
        Declaration.clazz('MacroStartedResponse',
            "Host's response to a [MacroStartedRequest].", []),
        Declaration.union(
            'MacroRequest', 'A request sent from macro to host.', [
          'MacroStartedRequest',
          'QueryRequest',
        ], [
          Field('id', 'int',
              'The id of this request, must be returned in responses.',
              required: true),
        ]),
        Declaration.clazz(
            'Protocol',
            'The macro to host protocol version and encoding. '
                'TODO(davidmorgan): add the version.',
            [
              Field(
                  'encoding',
                  'String',
                  'The wire format: json or binary. '
                      'TODO(davidmorgan): use an enum?'),
            ]),
        Declaration.clazz(
            'QueryRequest', "Macro's query about the code it should augment.", [
          Field('query', 'Query', 'The query.'),
        ]),
        Declaration.clazz(
            'QueryResponse', "Host's response to a [QueryRequest].", [
          Field('model', 'Model', 'The model.'),
        ]),
        Declaration.union('Response', 'A response to a request', [
          'AugmentResponse',
          'ErrorResponse',
          'MacroStartedResponse',
          'QueryResponse',
        ], [
          Field('requestId', 'int',
              'The id of the request this is responding to.',
              required: true),
        ]),
      ]),
]);
