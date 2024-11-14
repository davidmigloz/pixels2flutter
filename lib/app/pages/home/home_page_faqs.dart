import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageFAQsSection extends StatelessWidget {
  const HomePageFAQsSection({super.key});

  static const _faqs = [
    _FAQsItem(
      title: 'Is pixels2flutter.dev free?',
      content: 'Yes! [pixels2flutter.dev](https://pixels2flutter.dev) app is totally free.  \n'
          'But you need to provide your own model provider key (OpenAI, Google AI, etc.) to generate the code.  \n'
          r'The cost of each generation depends on the provider you use and the length of the code. '
          r'On average it costs around $0.01 when using OpenAI. '
          r'Google AI has a generous free tier that you can take advantage of.',
    ),
    _FAQsItem(
      title: 'Is pixels2flutter.dev open-source?',
      content: 'Yes! [pixels2flutter.dev](https://pixels2flutter.dev) app is fully open-source. '
          'It is built using Flutter web and [LangChain.dart](https://github.com/davidmigloz/langchain_dart).  \n'
          'You can find the code [here](https://github.com/davidmigloz/pixels2flutter). '
          "Don't forget to drop a star if you like it!",
    ),
    _FAQsItem(
      title: 'What can I expect from it?',
      content: 'Like any other generative-AI tool, the generated code may not be perfect. '
          'This tool is not meant to replace developers, but to support and empower them. '
          'Use the generated code as a starting point, review it carefully, and make the necessary adjustments. '
          'If the generated code is not good enough, try to provide more context in the "Additional instructions" field '
          '(e.g. use widget X to implement Y, do Z when the user taps on the button, etc.).',
    ),
    _FAQsItem(
      title: 'Where can I get the OpenAI API key?',
      content: '1. Log in or sign up to the [OpenAI platform](https://platform.openai.com/docs/overview).\n'
          '2. Go to [Settings > Limits](https://platform.openai.com/account/limits) page and check your "Usage tier". '
          'Your account should be at least "Usage tier 1" to use the GPT-4o model. '
          'If it is not, you can buy \$5 worth of credits to upgrade your tier.\n'
          '3. Go to [Default project > API keys](https://platform.openai.com/api-keys) page.\n'
          '4. Click on the "Create new API key" button.\n'
          '5. Copy the key.\n'
          '6. *Recommended*: go to [Usage page](https://platform.openai.com/usage) and set a monthly limit to avoid surprises.\n\n',
    ),
    _FAQsItem(
      title: 'Where can I get the Google AI API key?',
      content: '1. Log in or sign up to [Google AI Studio](https://aistudio.google.com).\n'
          '2. Click on the [Get API key](https://aistudio.google.com/app/apikey) button in the navigation rail.\n'
          '3. Click on the "Create API key" button.\n'
          '4. Copy the key.\n',
    ),
    _FAQsItem(
      title: 'Where can I get the GitHub API key?',
      content: '1. Log in or sign up to [GitHub](https://github.com).\n'
          '2. Go to the [Personal access tokens](https://github.com/settings/tokens?type=beta) page.\n'
          '3. Select "Fine-grained personal access tokens".\n'
          '4. Give it a name (e.g. pixels2flutter).\n'
          '5. Set the expiration date (e.g. 30 days).\n'
          '6. Repository access: "Public Repositories (read-only)".\n'
          '7. Permissions: select only "Gists - Access: Read and Write".\n'
          '8. Click "Generate" and copy the token.\n',
    ),
    _FAQsItem(
      title: "Isn't it risky to provide my API keys?",
      content:
          'Yes, it is. But that is the only way we can offer [pixels2flutter.dev](https://pixels2flutter.dev) app for free. '
          'That is also why it is open-source. You can check the code and run it locally if you want to be 100% sure '
          'that your API keys are not being misused.',
    ),
    _FAQsItem(
      title: 'Can I use an open-source alternative to OpenAI or Google AI?',
      content: r'At the moment, [pixels2flutter.dev](https://pixels2flutter.dev) only supports '
          r'[OpenAI GPT-4o](https://openai.com/index/hello-gpt-4o) and [Google Gemini 1.5 Pro](https://deepmind.google/technologies/gemini/pro) models. '
          r'But as soon as there is an open-source alternative that produces similar results '
          r'we will add support for it.',
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: ColoredBox(
        color: const Color(0xFFF8F2FF),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 48),
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Card(
              elevation: 2,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'FAQs',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (final context, final index) {
                        return _FAQsItemWidget(item: _faqs[index]);
                      },
                      itemCount: _faqs.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FAQsItemWidget extends StatefulWidget {
  const _FAQsItemWidget({
    required this.item,
  });

  final _FAQsItem item;

  @override
  State<_FAQsItemWidget> createState() => _FAQsItemWidgetState();
}

class _FAQsItemWidgetState extends State<_FAQsItemWidget> {
  late ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: const Icon(
          Icons.double_arrow,
          size: 12,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            widget.item.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        expandedAlignment: Alignment.topLeft,
        children: <Widget>[
          Builder(
            builder: (final BuildContext context) {
              return Container(
                padding: const EdgeInsets.only(
                  left: 52,
                  right: 16,
                  bottom: 16,
                ),
                child: MarkdownBody(
                  data: widget.item.content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  onTapLink: (final text, final href, final title) async {
                    await launchUrl(Uri.parse(href!));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FAQsItem {
  const _FAQsItem({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}
