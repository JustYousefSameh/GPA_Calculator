// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$semesterStreamHash() => r'77a35370da74e66af57d4663065b2c076934e55f';

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
String _$semesterControllerHash() =>
    r'17fa9d7452d06b2fea01c7f68cdd3fa3dc8efa23';

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
