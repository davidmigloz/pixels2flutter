import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:result_dart/result_dart.dart';

import '../entities/entities.dart';
import 'use_case.dart';

@injectable
class GenerateCodeFromImageUseCase
    implements StreamUseCase<GenerateCodeFromImageUseCaseParams, String, GenerateCodeFromImageFailure> {
  const GenerateCodeFromImageUseCase(
    this._chatOpenAI,
    this._chatGoogleGenerativeAI,
  );

  final ChatOpenAI _chatOpenAI;
  final ChatGoogleGenerativeAI _chatGoogleGenerativeAI;

  @override
  Stream<Result<String, GenerateCodeFromImageFailure>> call({
    required final GenerateCodeFromImageUseCaseParams params,
  }) async* {
    try {
      final chatModel = _getChatModel(params.provider);
      final chain = chatModel.pipe(const StringOutputParser());

      final prompt = _getPrompt(params.provider, params.screenshot, params.additionalInstructions);

      final stream = chain.stream(prompt);

      yield* stream.transform(
        // Wrap the result into a Result class and map errors
        StreamTransformer((final input, final cancelOnError) {
          final controller = StreamController<Result<String, GenerateCodeFromImageFailure>>(sync: true);
          controller.onListen = () {
            final subscription = input.listen(
              (final String data) => controller.add(Result.success(data)),
              onError: (final Object error) => controller.add(Result.failure(_mapErrorToFailure(error))),
              onDone: controller.close,
              cancelOnError: cancelOnError,
            );
            controller
              ..onPause = subscription.pause
              ..onResume = subscription.resume
              ..onCancel = subscription.cancel;
          };
          return controller.stream.listen(null);
        }),
      );
    } on Exception catch (e) {
      yield Result.failure(_mapErrorToFailure(e));
    }
  }

  Runnable<PromptValue, ChatModelOptions, ChatResult> _getChatModel(final GenerateCodeProvider provider) {
    return switch (provider) {
      GenerateCodeProvider.openAI => _chatOpenAI.bind(
          const ChatOpenAIOptions(
            model: 'gpt-4-vision-preview',
            maxTokens: 4096,
            temperature: 0,
          ),
        ),
      GenerateCodeProvider.googleAI => _chatGoogleGenerativeAI.bind(
          const ChatGoogleGenerativeAIOptions(
            model: 'gemini-pro-vision',
            maxOutputTokens: 4096,
            temperature: 0,
          ),
        ),
    };
  }

  PromptValue _getPrompt(
    final GenerateCodeProvider provider,
    final Screenshot screenshot,
    final String? additionalInstructions,
  ) {
    final systemPrompt = _getSystemPrompt(provider);
    final userPrompt = _getUserPrompt(provider);
    return PromptValue.chat([
      if (systemPrompt != null) systemPrompt,
      ChatMessage.human(
        ChatMessageContent.multiModal([
          ChatMessageContent.image(
            mimeType: screenshot.mimeType,
            data: base64Encode(screenshot.data),
            imageDetail: ChatMessageContentImageDetail.high,
          ),
          if (additionalInstructions != null) ChatMessageContent.text(additionalInstructions),
          if (userPrompt != null) userPrompt,
        ]),
      ),
    ]);
  }

  ChatMessage? _getSystemPrompt(final GenerateCodeProvider provider) {
    return switch (provider) {
      GenerateCodeProvider.openAI => ChatMessage.system(_openAISystemPrompt),
      GenerateCodeProvider.googleAI => null,
    };
  }

  ChatMessageContent? _getUserPrompt(final GenerateCodeProvider provider) {
    return switch (provider) {
      GenerateCodeProvider.openAI => ChatMessageContent.text(_openAIUserPrompt),
      GenerateCodeProvider.googleAI => ChatMessageContent.text(_googleAIUserPrompt),
    };
  }

  GenerateCodeFromImageFailure _mapErrorToFailure(final Object e) {
    if (e is OpenAIClientException) {
      if (e.body?.toString().contains('invalid_api_key') ?? false) {
        return GenerateCodeFromImageFailure.invalidApiKey;
      } else if (e.body?.toString().contains('model_not_found') ?? false) {
        return GenerateCodeFromImageFailure.noAccessToGpt4V;
      }
    }
    return GenerateCodeFromImageFailure.unknown;
  }
}

class GenerateCodeFromImageUseCaseParams {
  const GenerateCodeFromImageUseCaseParams({
    required this.provider,
    required this.screenshot,
    this.additionalInstructions,
  });

  final GenerateCodeProvider provider;
  final Screenshot screenshot;
  final String? additionalInstructions;
}

enum GenerateCodeProvider {
  openAI,
  googleAI,
}

enum GenerateCodeFromImageFailure {
  invalidApiKey,
  noAccessToGpt4V,
  unknown,
}

const _openAISystemPrompt = '''
You are an expert developer specialized in implementing Flutter apps using Dart.

I will provide you with an image of a reference design and some instructions and it will be your job to implement the corresponding app using Flutter and Dart.

- Pay close attention to background color, text color, font size, font family, padding, margin, border, etc. in the design. Match the colors and sizes exactly.
- If it contains text, use the exact text in the design.
- Repeat elements as needed to match the screenshot. For example, if there are 15 items, the code should have 15 items. DO NOT LEAVE comments like "// Repeat for each item".
- For images, use placeholder images from https://placehold.co and include a detailed description of the image in a `description` query parameter so that an image generation AI can generate the image later (e.g. https://placehold.co/40x40?description=An%20image%20of%20a%20cat).

Try your best to figure out what the designer and product owner want and make it happen. If there are any questions or underspecified features, use what you know about applications, user experience, and app design patterns to "fill in the blanks". If you're unsure of how the designs should work, take a guess—it's better for you to get it wrong than to leave things incomplete.

Technical details:
- Use Dart with null safety
- Variables that are initialized later should be declared as `late` (e.g. `late AnimationController controller;`)
- Mind that context can be accessed during `initState`, if you need it wrap the code with `Future.microtask(() => ...)` to be able to access it.
- If you need to assign an `int` to a `double` variable use `toDouble()`
- Use Material 3
- Set debugShowCheckedModeBanner to false in MaterialApp
- Use only official Flutter packages unless otherwise specified

RETURN ONLY THE CODE FOR THE `main.dart` FILE wrapped in a Markdown code block (```dart {CODE}```).
Don't include any explanations or comments.

Remember: you love your designers and POs and want them to be happy. The more complete and impressive your app, the happier they will be. Let's think step by step. Good luck, you've got this!''';

const _openAIUserPrompt = '''
Here are the latest designs.

Implement a new Flutter app based on these designs and instructions.''';

const _googleAIUserPrompt = '''
You are an expert developer specialized in implementing Flutter apps using Dart.

I will provide you with an image of a reference design and some instructions and it will be your job to implement the corresponding app using Flutter and Dart.

- Pay close attention to background color, text color, font size, font family, padding, margin, border, etc. in the design. Match the colors and sizes exactly.
- If it contains text, use the exact text in the design.
- Repeat elements as needed to match the screenshot. For example, if there are 15 items, the code should have 15 items. DO NOT LEAVE comments like "// Repeat for each item".
- For images, use placeholder images from https://placehold.co and include a detailed description of the image in a `description` query parameter so that an image generation AI can generate the image later (e.g. https://placehold.co/40x40?description=An%20image%20of%20a%20cat).

Try your best to figure out what the designer and product owner want and make it happen. If there are any questions or underspecified features, use what you know about applications, user experience, and app design patterns to "fill in the blanks". If you're unsure of how the designs should work, take a guess—it's better for you to get it wrong than to leave things incomplete.

Technical details:
- Use Dart with null safety
- Variables that are initialized later should be declared as `late` (e.g. `late AnimationController controller;`)
- Mind that context can be accessed during `initState`, if you need it wrap the code with `Future.microtask(() => ...)` to be able to access it.
- If you need to assign an `int` to a `double` variable use `toDouble()`
- Use Material 3
- Set debugShowCheckedModeBanner to false in MaterialApp
- Use only official Flutter packages unless otherwise specified

RETURN ONLY THE CODE FOR THE `main.dart` FILE wrapped in a Markdown code block (```dart {CODE} ```).
Don't include any explanations or comments.

Remember: you love your designers and POs and want them to be happy. The more complete and impressive your app, the happier they will be. Let's think step by step. Good luck, you've got this!

Here are the latest designs.

Implement a new Flutter app based on these designs and instructions.''';
