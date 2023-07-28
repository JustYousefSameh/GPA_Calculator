import 'package:fpdart/fpdart.dart';
import 'package:gpa_calculator/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
