import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SettingsRepository {
  const SettingsRepository(this._storage);

  final FlutterSecureStorage _storage;

  static const _openAiKey = 'openai_key';
  static const _googleAiKey = 'googleai_key';
  static const _githubKey = 'github_key';

  Future<String?> getOpenAiKey() {
    return _storage.read(key: _openAiKey);
  }

  Future<void> saveOpenAiKey(final String openAiKey) async {
    await _storage.write(key: _openAiKey, value: openAiKey);
  }

  Future<String?> getGoogleAiKey() {
    return _storage.read(key: _googleAiKey);
  }

  Future<void> saveGoogleAiKey(final String googleAiKey) async {
    await _storage.write(key: _googleAiKey, value: googleAiKey);
  }

  Future<String?> getGitHubKey() {
    return _storage.read(key: _githubKey);
  }

  Future<void> saveGitHubKey(final String githubKey) async {
    await _storage.write(key: _githubKey, value: githubKey);
  }
}
