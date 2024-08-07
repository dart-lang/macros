// This file is generated. To make changes edit schemas/*.schema.json
// then run from the repo root: dart tool/model_generator/bin/main.dart

import 'package:dart_model/dart_model.dart';

/// A request to a macro to augment some code.
extension type AugmentRequest.fromJson(Map<String, Object?> node) {
  AugmentRequest({
    int? phase,
  }) : this.fromJson({
          if (phase != null) 'phase': phase,
        });

  /// Which phase to run: 1, 2 or 3.
  int get phase => node['phase'] as int;
}

/// Macro's response to an [AugmentRequest]: the resulting augmentations.
extension type AugmentResponse.fromJson(Map<String, Object?> node) {
  AugmentResponse({
    List<Augmentation>? augmentations,
  }) : this.fromJson({
          if (augmentations != null) 'augmentations': augmentations,
        });

  /// The augmentations.
  List<Augmentation> get augmentations =>
      (node['augmentations'] as List).cast();
}

/// A macro host server endpoint. TODO(davidmorgan): this should be a oneOf supporting different types of connection. TODO(davidmorgan): it's not clear if this belongs in this package! But, where else?
extension type HostEndpoint.fromJson(Map<String, Object?> node) {
  HostEndpoint({
    int? port,
  }) : this.fromJson({
          if (port != null) 'port': port,
        });

  /// TCP port to connect to.
  int get port => node['port'] as int;
}

/// Information about a macro that the macro provides to the host.
extension type MacroDescription.fromJson(Map<String, Object?> node) {
  MacroDescription({
    List<int>? runsInPhases,
  }) : this.fromJson({
          if (runsInPhases != null) 'runsInPhases': runsInPhases,
        });

  /// Phases that the macro runs in: 1, 2 and/or 3.
  List<int> get runsInPhases => (node['runsInPhases'] as List).cast();
}

/// Informs the host that a macro has started.
extension type MacroStartedRequest.fromJson(Map<String, Object?> node) {
  MacroStartedRequest({
    MacroDescription? macroDescription,
  }) : this.fromJson({
          if (macroDescription != null) 'macroDescription': macroDescription,
        });
  MacroDescription get macroDescription =>
      node['macroDescription'] as MacroDescription;
}

/// Host's response to a [MacroStartedRequest].
extension type MacroStartedResponse.fromJson(Map<String, Object?> node) {
  MacroStartedResponse() : this.fromJson({});
}
