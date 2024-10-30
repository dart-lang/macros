// This file is generated. To make changes edit tool/dart_model_generator
// then run from the repo root: dart tool/dart_model_generator/bin/main.dart

// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/deep_cast_map.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/json_buffer/json_buffer_builder.dart';
// ignore: implementation_imports,unused_import,prefer_relative_imports
import 'package:dart_model/src/scopes.dart';

/// Request to pick a protocol.
extension type HandshakeRequest.fromJson(Map<String, Object?> node)
    implements Object {
  HandshakeRequest({
    List<Protocol>? protocols,
  }) : this.fromJson({
          if (protocols != null) 'protocols': protocols,
        });

  /// Supported protocols.
  List<Protocol> get protocols => (node['protocols'] as List).cast();
  int get identityHash =>
      Object.hashAll(protocols.map((entry) => entry.identityHash));
}

/// The picked protocol, or `null` if no requested protocol is supported.
extension type HandshakeResponse.fromJson(Map<String, Object?> node)
    implements Object {
  HandshakeResponse({
    Protocol? protocol,
  }) : this.fromJson({
          if (protocol != null) 'protocol': protocol,
        });

  /// Supported protocol.
  Protocol? get protocol => node['protocol'] as Protocol?;
  int get identityHash => protocol?.identityHash ?? 0;
}

/// The macro to host protocol version and encoding. TODO(davidmorgan): add the version.
extension type Protocol.fromJson(Map<String, Object?> node) implements Object {
  Protocol({
    ProtocolEncoding? encoding,
    ProtocolVersion? version,
  }) : this.fromJson({
          if (encoding != null) 'encoding': encoding,
          if (version != null) 'version': version,
        });

  /// The initial protocol for any `host<->macro` connection.
  static Protocol handshakeProtocol = Protocol(
      encoding: ProtocolEncoding.json, version: ProtocolVersion.handshake);

  /// The wire format: json or binary.
  ProtocolEncoding get encoding => node['encoding'] as ProtocolEncoding;

  /// The protocol version, a name and number.
  ProtocolVersion get version => node['version'] as ProtocolVersion;
  int get identityHash => Object.hash(
        encoding.identityHash,
        version.identityHash,
      );
}

/// The wire encoding used.
extension type const ProtocolEncoding.fromJson(String string)
    implements Object {
  static const ProtocolEncoding json = ProtocolEncoding.fromJson('json');
  static const ProtocolEncoding binary = ProtocolEncoding.fromJson('binary');
  int get identityHash => string.hashCode;
}

/// The protocol version.
extension type const ProtocolVersion.fromJson(String string) implements Object {
  static const ProtocolVersion handshake =
      ProtocolVersion.fromJson('handshake');
  static const ProtocolVersion macros1 = ProtocolVersion.fromJson('macros1');
  int get identityHash => string.hashCode;
}
