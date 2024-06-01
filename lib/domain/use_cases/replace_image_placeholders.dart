import 'package:injectable/injectable.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:result_dart/result_dart.dart';

import 'use_case.dart';

@injectable
class ReplaceImagePlaceholdersUseCase
    implements AsyncUseCase<ReplaceImagePlaceholdersUseCaseParams, String, Exception> {
  const ReplaceImagePlaceholdersUseCase(this._dallETool);

  final OpenAIDallETool _dallETool;

  @override
  Future<Result<String, Exception>> call({
    required final ReplaceImagePlaceholdersUseCaseParams params,
  }) async {
    try {
      final generatedCode = params.code;
      // Get image uris
      final regex = RegExp(r"https://placehold\.co/[^']+");
      final matches = regex.allMatches(generatedCode);
      final uris = matches.map((final m) => m.group(0)).toList(growable: false);

      // Generate images
      final dallE = _dallETool.bind(
        const OpenAIDallEToolOptions(
          model: 'dall-e-2',
          size: ImageSize.v256x256,
        ),
      );
      final images = await Future.wait(
        uris.map((final uri) {
          final description = Uri.parse(uri ?? '').queryParameters['description'] ?? '';
          return dallE.invoke(description);
        }),
      );

      // Replace placeholders with images
      String finalCode = generatedCode;
      for (var i = 0; i < uris.length; i++) {
        finalCode = finalCode.replaceAll(
          uris[i]!,
          'https://corsproxy.io/?${Uri.encodeQueryComponent(images[i].trim())}',
        );
      }
      return Result.success(finalCode);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}

class ReplaceImagePlaceholdersUseCaseParams {
  const ReplaceImagePlaceholdersUseCaseParams({
    required this.code,
  });

  final String code;
}
