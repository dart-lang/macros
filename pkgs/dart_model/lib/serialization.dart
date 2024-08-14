import 'dart:typed_data';

import 'src/json_buffer.dart';

extension SerializeExtension on Map<String, Object?> {
  Uint8List serializeToBinary() => JsonBuffer.serializeToBinary(this);
}

extension DeserializeExtension on Uint8List {
  Map<String, Object?> deserializeFromBinary() =>
      JsonBuffer.deserialize(this).asMap;
}
