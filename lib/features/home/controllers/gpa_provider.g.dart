// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpa_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$semesterGPAHash() => r'2bb3ac2faa05310c5bb7a2045592f6d24bbd8ae9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [semesterGPA].
@ProviderFor(semesterGPA)
const semesterGPAProvider = SemesterGPAFamily();

/// See also [semesterGPA].
class SemesterGPAFamily extends Family<AsyncValue<double>> {
  /// See also [semesterGPA].
  const SemesterGPAFamily();

  /// See also [semesterGPA].
  SemesterGPAProvider call(
    int semesterIndex,
  ) {
    return SemesterGPAProvider(
      semesterIndex,
    );
  }

  @override
  SemesterGPAProvider getProviderOverride(
    covariant SemesterGPAProvider provider,
  ) {
    return call(
      provider.semesterIndex,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'semesterGPAProvider';
}

/// See also [semesterGPA].
class SemesterGPAProvider extends AutoDisposeFutureProvider<double> {
  /// See also [semesterGPA].
  SemesterGPAProvider(
    int semesterIndex,
  ) : this._internal(
          (ref) => semesterGPA(
            ref as SemesterGPARef,
            semesterIndex,
          ),
          from: semesterGPAProvider,
          name: r'semesterGPAProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$semesterGPAHash,
          dependencies: SemesterGPAFamily._dependencies,
          allTransitiveDependencies:
              SemesterGPAFamily._allTransitiveDependencies,
          semesterIndex: semesterIndex,
        );

  SemesterGPAProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.semesterIndex,
  }) : super.internal();

  final int semesterIndex;

  @override
  Override overrideWith(
    FutureOr<double> Function(SemesterGPARef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SemesterGPAProvider._internal(
        (ref) => create(ref as SemesterGPARef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        semesterIndex: semesterIndex,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _SemesterGPAProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SemesterGPAProvider && other.semesterIndex == semesterIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, semesterIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SemesterGPARef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `semesterIndex` of this provider.
  int get semesterIndex;
}

class _SemesterGPAProviderElement
    extends AutoDisposeFutureProviderElement<double> with SemesterGPARef {
  _SemesterGPAProviderElement(super.provider);

  @override
  int get semesterIndex => (origin as SemesterGPAProvider).semesterIndex;
}

String _$gpaStateHash() => r'8287e5faf6ec8dfdb536ad69d9602bcace401de3';

/// See also [gpaState].
@ProviderFor(gpaState)
final gpaStateProvider = AutoDisposeFutureProvider<List<double>>.internal(
  gpaState,
  name: r'gpaStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gpaStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GpaStateRef = AutoDisposeFutureProviderRef<List<double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
