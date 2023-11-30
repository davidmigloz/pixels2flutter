import 'package:github/github.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import 'use_case.dart';

@injectable
class CreateGistUseCase implements AsyncUseCase<CreateGistUseCaseParams, String, Exception> {
  const CreateGistUseCase(this._github);

  final GitHub _github;

  @override
  Future<Result<String, Exception>> call({
    required final CreateGistUseCaseParams params,
  }) async {
    try {
      final codeRegEx = RegExp(r'```dart\n([^`]*)```');
      final cleanedCode = codeRegEx.firstMatch(params.code)?.group(1) ?? '';

      final res = await _github.gists.createGist(
        {'main.dart': cleanedCode},
        description: 'Generated code from pixels2flutter.dev',
        public: true,
      );
      return Result.success(res.id!);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}

class CreateGistUseCaseParams {
  const CreateGistUseCaseParams({
    required this.code,
  });

  final String code;
}
