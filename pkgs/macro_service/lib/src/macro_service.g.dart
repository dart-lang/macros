// This file is generated. To make changes edit schemas/*.schema.json
// then run from the repo root: dart tool/model_generator/bin/main.dart

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
  AugmentResponse() : this.fromJson({});
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
    bool? runsInPhaseOne,
    bool? runsInPhaseTwo,
    bool? runsInPhaseThree,
  }) : this.fromJson({
          if (runsInPhaseOne != null) 'runsInPhaseOne': runsInPhaseOne,
          if (runsInPhaseTwo != null) 'runsInPhaseTwo': runsInPhaseTwo,
          if (runsInPhaseThree != null) 'runsInPhaseThree': runsInPhaseThree,
        });

  /// Whether the macro runs in phase one to produce types.
  bool get runsInPhaseOne => node['runsInPhaseOne'] as bool;

  /// Whether the macro runs in phase two to produce declarations.
  bool get runsInPhaseTwo => node['runsInPhaseTwo'] as bool;

  /// Whether the macro runs in phase three to produce definitions.
  bool get runsInPhaseThree => node['runsInPhaseThree'] as bool;
}
