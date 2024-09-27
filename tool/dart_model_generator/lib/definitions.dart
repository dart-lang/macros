// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'generate_dart_model.dart';

final schemas = Schemas([
  Schema(
    schemaPath: 'handshake.schema.json',
    codePackage: 'macro_service',
    codePath: 'src/handshake.g.dart',
    rootTypes: ['HandshakeRequest', 'HandshakeResponse'],
    declarations: [
      Definition.clazz('HandshakeRequest',
          description: 'Request to pick a protocol.',
          properties: [
            Property(
              'protocols',
              type: 'List<Protocol>',
              description: 'Supported protocols.',
            ),
          ]),
      Definition.clazz('HandshakeResponse',
          description:
              'The picked protocol, or `null` if no requested protocol '
              'is supported.',
          properties: [
            Property(
              'protocol',
              type: 'Protocol',
              description: 'Supported protocol.',
              nullable: true,
            ),
          ]),
      Definition.clazz('Protocol',
          description: 'The macro to host protocol version and encoding. '
              'TODO(davidmorgan): add the version.',
          properties: [
            Property('encoding',
                type: 'ProtocolEncoding',
                description: 'The wire format: json or binary.'),
            Property('version',
                type: 'ProtocolVersion',
                description: 'The protocol version, a name and number.'),
          ],
          extraCode: '''
/// The initial protocol for any `host<->macro` connection.
static Protocol handshakeProtocol = Protocol(
    encoding: ProtocolEncoding.json, version: ProtocolVersion.handshake);
'''),
      Definition.$enum('ProtocolEncoding',
          description: 'The wire encoding used.', values: ['json', 'binary']),
      Definition.$enum('ProtocolVersion',
          description: 'The protocol version.',
          values: ['handshake', 'macros1']),
    ],
  ),
  Schema(
      schemaPath: 'dart_model.schema.json',
      codePackage: 'dart_model',
      codePath: 'src/dart_model.g.dart',
      rootTypes: [
        'Model',
      ],
      declarations: [
        Definition.clazz(
          'Augmentation',
          createInBuffer: true,
          description: 'An augmentation to Dart code. '
              'TODO(davidmorgan): this is a placeholder.',
          properties: [
            Property('code', type: 'String', description: 'Augmentation code.'),
          ],
        ),
        Definition.nullTypedef('DynamicTypeDesc',
            description:
                'The type-hierarchy representation of the type `dynamic`.'),
        Definition.clazz('FunctionTypeDesc',
            description: 'A static type representation for function types.',
            createInBuffer: true,
            properties: [
              Property('returnType',
                  type: 'StaticTypeDesc',
                  description: 'The return type of this function type.'),
              Property('typeParameters',
                  type: 'List<StaticTypeParameterDesc>',
                  description:
                      'Static type parameters introduced by this function '
                      'type.'),
              Property('requiredPositionalParameters',
                  type: 'List<StaticTypeDesc>'),
              Property('optionalPositionalParameters',
                  type: 'List<StaticTypeDesc>'),
              Property('namedParameters',
                  type: 'List<NamedFunctionTypeParameter>'),
            ]),
        Definition.clazz('MetadataAnnotation',
            description: 'A metadata annotation.',
            createInBuffer: true,
            properties: [
              Property('type',
                  type: 'QualifiedName',
                  description: 'The type of the annotation.'),
            ]),
        Definition.clazz(
          'Interface',
          description: 'An interface.',
          createInBuffer: true,
          properties: [
            Property('metadataAnnotations',
                type: 'List<MetadataAnnotation>',
                description:
                    'The metadata annotations attached to this interface.'),
            Property('members',
                type: 'Map<Member>', description: 'Map of members by name.'),
            Property('thisType',
                type: 'NamedTypeDesc',
                description:
                    'The type of the expression `this` when used in this '
                    'interface.'),
            Property('properties',
                type: 'Properties',
                description: 'The properties of this interface.'),
          ],
        ),
        Definition.clazz('Library',
            description: 'Library.',
            createInBuffer: true,
            properties: [
              Property('scopes',
                  type: 'Map<Interface>', description: 'Scopes by name.'),
            ]),
        // TODO(davidmorgan): make `Member` a union.
        Definition.clazz('Member',
            description: 'Member of a scope.',
            createInBuffer: true,
            properties: [
              Property('properties',
                  type: 'Properties',
                  description: 'The properties of this member.'),
              Property(
                'returnType',
                type: 'StaticTypeDesc',
                description: 'The return type of this member, if it has one.',
              ),
            ]),
        Definition.clazz('Model',
            description: 'Partial model of a corpus of Dart source code.',
            createInBuffer: true,
            properties: [
              Property('uris',
                  type: 'Map<Library>', description: 'Libraries by URI.'),
              Property('types',
                  type: 'TypeHierarchy',
                  description: 'The resolved static type hierarchy.'),
            ]),
        Definition.clazz('NamedFunctionTypeParameter',
            description:
                'A resolved named parameter as part of a [FunctionTypeDesc].',
            createInBuffer: true,
            properties: [
              Property('name', type: 'String'),
              Property('required', type: 'bool'),
              Property('type', type: 'StaticTypeDesc'),
            ]),
        Definition.clazz('NamedRecordField',
            description:
                'A named field in a [RecordTypeDesc], consisting of the field '
                'name and the associated type.',
            createInBuffer: true,
            properties: [
              Property('name', type: 'String'),
              Property('type', type: 'StaticTypeDesc'),
            ]),
        Definition.clazz('NamedTypeDesc',
            description: 'A resolved static type.',
            createInBuffer: true,
            properties: [
              Property('name', type: 'QualifiedName'),
              Property('instantiation', type: 'List<StaticTypeDesc>'),
            ]),
        Definition.nullTypedef('NeverTypeDesc',
            description: 'Representation of the bottom type [Never].'),
        Definition.clazz(
          'NullableTypeDesc',
          description: 'A Dart type of the form `T?` for an inner type `T`.',
          createInBuffer: true,
          properties: [
            Property('inner',
                type: 'StaticTypeDesc', description: 'The type T.')
          ],
        ),
        Definition.clazz('Properties',
            description: 'Set of boolean properties.',
            createInBuffer: true,
            properties: [
              Property('isAbstract',
                  type: 'bool',
                  description:
                      'Whether the entity is abstract, meaning it has no '
                      'definition.'),
              Property('isClass',
                  type: 'bool', description: 'Whether the entity is a class.'),
              Property('isGetter',
                  type: 'bool', description: 'Whether the entity is a getter.'),
              Property('isField',
                  type: 'bool', description: 'Whether the entity is a field.'),
              Property('isMethod',
                  type: 'bool', description: 'Whether the entity is a method.'),
              Property('isStatic',
                  type: 'bool', description: 'Whether the entity is static.'),
            ]),
        Definition.clazz('QualifiedName',
            description: 'A URI combined with a name.',
            createInBuffer: true,
            properties: [
              Property('uri',
                  type: 'String',
                  description: 'The URI of the file containing the name.'),
              Property('name', type: 'String', description: 'The name.'),
            ],
            extraCode: r'''
/// Parses [string] of the form `uri#name`.
static QualifiedName parse(String string) {
  final index = string.indexOf('#');
  if (index == -1) throw ArgumentError('Expected `#` in string: $string');
  return QualifiedName(
    uri: string.substring(0, index), name: string.substring(index + 1));
}
'''),
        Definition.clazz('Query',
            description: 'Query about a corpus of Dart source code. '
                'TODO(davidmorgan): this queries about a single class, expand '
                'to a union type for different types of queries.',
            properties: [
              Property('target',
                  type: 'QualifiedName',
                  description: 'The class to query about.'),
            ]),
        Definition.clazz('RecordTypeDesc',
            description: 'A resolved record type in the type hierarchy.',
            createInBuffer: true,
            properties: [
              Property('positional', type: 'List<StaticTypeDesc>'),
              Property('named', type: 'List<NamedRecordField>')
            ]),
        Definition.union('StaticTypeDesc',
            description:
                'A partially-resolved description of a type as it appears in '
                "Dart's type hierarchy.",
            createInBuffer: true,
            types: [
              'DynamicTypeDesc',
              'FunctionTypeDesc',
              'NamedTypeDesc',
              'NeverTypeDesc',
              'NullableTypeDesc',
              'RecordTypeDesc',
              'TypeParameterTypeDesc',
              'VoidTypeDesc',
            ],
            properties: []),
        Definition.clazz('StaticTypeParameterDesc',
            description:
                'A resolved type parameter introduced by a [FunctionTypeDesc].',
            createInBuffer: true,
            properties: [
              Property('identifier', type: 'int'),
              Property('bound', type: 'StaticTypeDesc', nullable: true),
            ]),
        Definition.clazz('TypeHierarchy',
            description:
                "View of a subset of a Dart program's type hierarchy as part "
                'of a queried model.',
            createInBuffer: true,
            properties: [
              Property('named',
                  type: 'Map<TypeHierarchyEntry>',
                  description:
                      'Map of qualified interface names to their resolved '
                      'named type.')
            ]),
        Definition.clazz('TypeHierarchyEntry',
            description:
                "Entry of an interface in Dart's type hierarchy, along with "
                'supertypes.',
            createInBuffer: true,
            properties: [
              Property('typeParameters',
                  type: 'List<StaticTypeParameterDesc>',
                  description:
                      'Type parameters defined on this interface-defining '
                      'element.'),
              Property('self',
                  type: 'NamedTypeDesc',
                  description:
                      'The named static type represented by this entry.'),
              Property('supertypes',
                  type: 'List<NamedTypeDesc>',
                  description: 'All direct supertypes of this type.'),
            ]),
        Definition.clazz('TypeParameterTypeDesc',
            description: 'A type formed by a reference to a type parameter.',
            createInBuffer: true,
            properties: [
              Property('parameterId', type: 'int'),
            ]),
        Definition.nullTypedef('VoidTypeDesc',
            description:
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
        Definition.clazz('AugmentRequest',
            description: 'A request to a macro to augment some code.',
            properties: [
              Property('phase',
                  type: 'int', description: 'Which phase to run: 1, 2 or 3.'),
              Property('target',
                  type: 'QualifiedName',
                  description: 'The class to augment. '
                      'TODO(davidmorgan): expand to more types of target.'),
            ]),
        Definition.clazz('AugmentResponse',
            description:
                "Macro's response to an [AugmentRequest]: the resulting "
                'augmentations.',
            properties: [
              Property('augmentations',
                  type: 'List<Augmentation>',
                  description: 'The augmentations.'),
            ]),
        Definition.clazz('ErrorResponse',
            description: 'Request could not be handled.',
            properties: [
              Property('error', type: 'String', description: 'The error.'),
            ]),
        Definition.clazz('HostEndpoint',
            description:
                'A macro host server endpoint. TODO(davidmorgan): this should '
                'be a oneOf supporting different types of connection. '
                "TODO(davidmorgan): it's not clear if this belongs in this "
                'package! But, where else?',
            properties: [
              Property('port',
                  type: 'int', description: 'TCP port to connect to.'),
            ]),
        Definition.union('HostRequest',
            description: 'A request sent from host to macro.',
            types: [
              'AugmentRequest'
            ],
            properties: [
              Property('id',
                  type: 'int',
                  description:
                      'The id of this request, must be returned in responses.',
                  required: true),
              Property(
                'macroAnnotation',
                type: 'QualifiedName',
                description:
                    'The annotation identifying the macro that should handle '
                    'the request.',
              )
            ]),
        Definition.clazz('MacroDescription',
            description:
                'Information about a macro that the macro provides to the '
                'host.',
            properties: [
              Property('annotation',
                  type: 'QualifiedName',
                  description: 'The annotation that triggers the macro.'),
              Property('runsInPhases',
                  type: 'List<int>',
                  description: 'Phases that the macro runs in: 1, 2 and/or 3.'),
            ]),
        Definition.clazz(
          'MacroStartedRequest',
          description: 'Informs the host that a macro has started.',
          properties: [
            Property('macroDescription',
                type: 'MacroDescription',
                description: 'The macro description.'),
          ],
        ),
        Definition.clazz('MacroStartedResponse',
            description: "Host's response to a [MacroStartedRequest].",
            properties: []),
        Definition.union('MacroRequest',
            description: 'A request sent from macro to host.',
            types: [
              'MacroStartedRequest',
              'QueryRequest',
            ],
            properties: [
              Property('id',
                  type: 'int',
                  description:
                      'The id of this request, must be returned in responses.',
                  required: true),
            ]),
        Definition.clazz('QueryRequest',
            description: "Macro's query about the code it should augment.",
            properties: [
              Property('query', type: 'Query', description: 'The query.'),
            ]),
        Definition.clazz('QueryResponse',
            description: "Host's response to a [QueryRequest].",
            properties: [
              Property('model', type: 'Model', description: 'The model.'),
            ]),
        Definition.union('Response',
            description: 'A response to a request',
            types: [
              'AugmentResponse',
              'ErrorResponse',
              'MacroStartedResponse',
              'QueryResponse',
            ],
            properties: [
              Property('requestId',
                  type: 'int',
                  description: 'The id of the request this is responding to.',
                  required: true),
            ]),
      ]),
]);
