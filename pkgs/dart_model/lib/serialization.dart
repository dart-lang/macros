import 'dart:typed_data';

import 'src/json_buffer/json_buffer_builder.dart';

extension SerializeExtension on Map<String, Object?> {
  Uint8List serializeToBinary() => JsonBufferBuilder.serializeToBinary(this);
}

extension DeserializeExtension on Uint8List {
  Map<String, Object?> deserializeFromBinary() =>
      JsonBufferBuilder.deserialize(this).map;
}
