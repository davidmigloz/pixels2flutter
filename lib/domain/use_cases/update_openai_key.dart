import 'package:injectable/injectable.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/dart.dart';
import 'use_case.dart';

@injectable
class UpdateOpenAiKeyUseCase implements AsyncUseCase<UpdateOpenAIKeyUseCaseParams, Unit, Exception> {
  const UpdateOpenAiKeyUseCase(
    this._chatOpenAI,
    this._dallETool,
    this._settingsRepository,
  );

  final ChatOpenAI _chatOpenAI;
  final OpenAIDallETool _dallETool;
  final SettingsRepository _settingsRepository;

  @override
  Future<Result<Unit, Exception>> call({
    required final UpdateOpenAIKeyUseCaseParams params,
  }) async {
    try {
      _chatOpenAI.apiKey = params.key;
      _dallETool.apiKey = params.key;
      if (params.storeApiKeys) {
        await _settingsRepository.saveOpenAiKey(params.key);
      }
      return Result.success(unit);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}

class UpdateOpenAIKeyUseCaseParams {
  const UpdateOpenAIKeyUseCaseParams({
    required this.key,
    required this.storeApiKeys,
  });

  final String key;
  final bool storeApiKeys;
}
