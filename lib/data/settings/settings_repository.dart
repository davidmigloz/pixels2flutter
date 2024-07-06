import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SettingsRepository {
  const SettingsRepository(this._storage);

  final FlutterSecureStorage _storage;

  static const _openAiKey = 'openai_key';
  static const _geminiKey = 'gemini_key';
  static const _githubKey = 'github_key';

  Future<String?> getOpenAiKey() {
    return _storage.read(key: _openAiKey);
  }

  Future<String?> getGeminiKey() {
    return _storage.read(key: _geminiKey);
  }

  Future<void> saveOpenAiKey(final String openAiKey) async {
    await _storage.write(key: _openAiKey, value: openAiKey);
  }

  Future<void> saveGeminiKey(final String geminiKey) async {
    await _storage.write(key: _geminiKey, value: geminiKey);
  }

  Future<String?> getGitHubKey() {
    return _storage.read(key: _githubKey);
  }

  Future<void> saveGitHubKey(final String githubKey) async {
    await _storage.write(key: _githubKey, value: githubKey);
  }
}
