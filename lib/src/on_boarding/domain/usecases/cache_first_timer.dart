import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';

class CacheFirstTimer extends UsecaseWithoutParams<void> {
  CacheFirstTimer(this._repository);

  final OnBoardingRepository _repository;

  @override
  ResultFuture<void> call() async => _repository.cacheFirstTimer();
}
