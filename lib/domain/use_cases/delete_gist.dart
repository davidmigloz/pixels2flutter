import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import 'use_case.dart';

@injectable
class DeleteGistUseCase implements AsyncUseCase<DeleteGistUseCaseParams, bool, Exception> {
  const DeleteGistUseCase(this._github);

  final GitHub _github;

  @override
  Future<Result<bool, Exception>> call({
    required final DeleteGistUseCaseParams params,
  }) async {
    try {
      final deleted = await _github.gists.deleteGist(params.gistId);
      return Result.success(deleted);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}

class DeleteGistUseCaseParams {
  const DeleteGistUseCaseParams({
    required this.gistId,
  });

  final String gistId;
}
