// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userIDHash() => r'455080ec0ccbe589d95b9e2c3e4111eaa04de99f';

/// See also [userID].
@ProviderFor(userID)
final userIDProvider = AutoDisposeProvider<String?>.internal(
  userID,
  name: r'userIDProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userIDHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserIDRef = AutoDisposeProviderRef<String?>;
String _$authStateChangeHash() => r'a499be9ace54e7e6a9a252c1a4b68b7854e03851';

/// See also [authStateChange].
@ProviderFor(authStateChange)
final authStateChangeProvider = AutoDisposeStreamProvider<User?>.internal(
  authStateChange,
  name: r'authStateChangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangeRef = AutoDisposeStreamProviderRef<User?>;
String _$authControllerHash() => r'71621687ff4cf107af259c2eea3502da06c41d87';

/// See also [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeNotifierProvider<AuthController, bool>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
