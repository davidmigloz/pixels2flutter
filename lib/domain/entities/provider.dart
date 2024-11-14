part of 'entities.dart';

enum GenerateCodeProvider {
  openAI,
  googleAI,
}

extension GenerateCodeProviderX on GenerateCodeProvider {
  String get displayName => switch (this) {
        GenerateCodeProvider.openAI => 'OpenAI',
        GenerateCodeProvider.googleAI => 'GoogleAI',
      };

  String get helperText => switch (this) {
        GenerateCodeProvider.openAI => 'Your OpenAI account should be at least "Usage tier 1" to use the GPT-4o model.',
        GenerateCodeProvider.googleAI => 'Your Google account should have enough quota to use Gemini 1.5 Pro model.',
      };

  String get invalidApiKeyText => switch (this) {
        GenerateCodeProvider.openAI =>
          'Invalid OpenAI API key. Please generate a valid key at platform.openai.com/api-keys.',
        GenerateCodeProvider.googleAI =>
          'Invalid Google API key. Please generate a valid key at aistudio.google.com/app/apikey.',
      };

  String get noAccessToModelText => switch (this) {
        GenerateCodeProvider.openAI => 'Your OpenAI account does not have access to the GPT-4o model. '
            'Please upgrade your account to "Usage tier 1" at platform.openai.com/account/billing '
            '(check the FAQs below for more info).',
        GenerateCodeProvider.googleAI => 'Your Google account does not have access to the Gemini 1.5 Pro model. '
            'Please check your account quota at aistudio.google.com/app/apikey '
            '(check the FAQs below for more info).',
      };
}
