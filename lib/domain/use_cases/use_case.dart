import 'package:result_dart/result_dart.dart';

abstract interface class UseCase<Params, Return> {
  Return call({required final Params params});
}

abstract interface class SyncUseCase<Params, Type extends Object, Error extends Object>
    implements UseCase<Params, Result<Type, Error>> {
  @override
  Result<Type, Error> call({required final Params params});
}

abstract interface class AsyncUseCase<Params, Type extends Object, Error extends Object>
    implements UseCase<Params, Future<Result<Type, Error>>> {
  @override
  Future<Result<Type, Error>> call({required final Params params});
}

abstract interface class StreamUseCase<Params, Type extends Object, Error extends Object>
    implements UseCase<Params, Stream<Result<Type, Error>>> {
  @override
  Stream<Result<Type, Error>> call({required final Params params});
}
