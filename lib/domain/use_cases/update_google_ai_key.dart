import 'package:injectable/injectable.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/dart.dart';
import 'use_case.dart';

@injectable
class UpdateGoogleAiKeyUseCase implements AsyncUseCase<UpdateGoogleAiKeyUseCaseParams, Unit, Exception> {
  const UpdateGoogleAiKeyUseCase(
    this._chatGoogleGenerativeAI,
    this._settingsRepository,
  );

  final ChatGoogleGenerativeAI _chatGoogleGenerativeAI;
  final SettingsRepository _settingsRepository;

  @override
  Future<Result<Unit, Exception>> call({
    required final UpdateGoogleAiKeyUseCaseParams params,
  }) async {
    try {
      _chatGoogleGenerativeAI.apiKey = params.key;
      if (params.storeApiKeys) {
        await _settingsRepository.saveGoogleAiKey(params.key);
      }
      return const Result.success(unit);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}

class UpdateGoogleAiKeyUseCaseParams {
  const UpdateGoogleAiKeyUseCaseParams({
    required this.key,
    required this.storeApiKeys,
  });

  final String key;
  final bool storeApiKeys;
}
