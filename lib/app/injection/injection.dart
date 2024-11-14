import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:github/github.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import '../navigation/router.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
void registerDependencies() => getIt.init();

@module
abstract class InjectionModule {
  @singleton
  GoRouter goRouter(final RouterFactory factory) => factory.build();

  FlutterSecureStorage get sharedPreference => const FlutterSecureStorage(
        webOptions: WebOptions(
          dbName: 'pixels2flutter',
          publicKey: 'pixels2flutterKey',
        ),
      );

  FilePicker get filePicker => FilePicker.platform;

  @singleton
  ChatOpenAI get chatOpenAI => ChatOpenAI();

  @singleton
  ChatGoogleGenerativeAI get chatGoogleGenerativeAI => ChatGoogleGenerativeAI();

  @singleton
  OpenAIDallETool get dallETool => OpenAIDallETool();

  @singleton
  GitHub get gitHub => GitHub();

  @singleton
  Future<Highlighter> get highlighter async {
    await Highlighter.initialize(['dart']);
    final theme = await HighlighterTheme.loadLightTheme();
    return Highlighter(
      language: 'dart',
      theme: theme,
    );
  }
}
