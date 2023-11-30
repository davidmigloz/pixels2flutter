import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/dart.dart';
import 'use_case.dart';

@injectable
class UpdateGitHubKeyUseCase
    implements AsyncUseCase<UpdateGitHubKeyUseCaseParams, Unit, Exception> {
  const UpdateGitHubKeyUseCase(
    this._github,
    this._settingsRepository,
  );

  final GitHub _github;
  final SettingsRepository _settingsRepository;

  @override
  Future<Result<Unit, Exception>> call({
    required final UpdateGitHubKeyUseCaseParams params,
  }) async {
    try {
      _github.auth = Authentication.withToken(params.key);
      if (params.storeApiKeys) {
        await _settingsRepository.saveGitHubKey(params.key);
      }
      return Result.success(unit);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}

class UpdateGitHubKeyUseCaseParams {
  const UpdateGitHubKeyUseCaseParams({
    required this.key,
    required this.storeApiKeys,
  });

  final String key;
  final bool storeApiKeys;
}
