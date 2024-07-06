import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/dart.dart';
import 'use_case.dart';

@injectable
class GetGeminiKeyUseCase implements AsyncUseCase<Unit, String, Exception> {
  const GetGeminiKeyUseCase(
    this._settingsRepository,
  );

  final SettingsRepository _settingsRepository;

  @override
  Future<Result<String, Exception>> call({
    final Unit params = unit,
  }) async {
    try {
      final key = await _settingsRepository.getGeminiKey();
      return Result.success(key ?? '');
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
