// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$semesterStreamHash() => r'91a397d1ae70e1e7cea0595b9e17be070aa7efa9';

/// See also [semesterStream].
@ProviderFor(semesterStream)
final semesterStreamProvider =
    AutoDisposeStreamProvider<List<SemsesterModel>>.internal(
  semesterStream,
  name: r'semesterStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$semesterStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SemesterStreamRef = AutoDisposeStreamProviderRef<List<SemsesterModel>>;
String _$semesterCounterHash() => r'1e01979f07303bb934bf7d0f3c0b7e27f921a9b3';

/// See also [SemesterCounter].
@ProviderFor(SemesterCounter)
final semesterCounterProvider =
    AutoDisposeAsyncNotifierProvider<SemesterCounter, int>.internal(
  SemesterCounter.new,
  name: r'semesterCounterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$semesterCounterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SemesterCounter = AutoDisposeAsyncNotifier<int>;
String _$semesterControllerHash() =>
    r'b2257e0a0510f514d9a43ae8839aac8f46146caa';

/// See also [SemesterController].
@ProviderFor(SemesterController)
final semesterControllerProvider = AutoDisposeAsyncNotifierProvider<
    SemesterController, List<SemsesterModel>>.internal(
  SemesterController.new,
  name: r'semesterControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$semesterControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SemesterController = AutoDisposeAsyncNotifier<List<SemsesterModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
