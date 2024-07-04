import 'package:flutter/material.dart';

import '../../assets/assets.gen.dart';

class HomePageHowItWorksSection extends StatelessWidget {
  const HomePageHowItWorksSection({super.key});

  static const _items = [
    _HowItWorksItem(
      title: 'Upload a screenshot',
      content: 'Select or drag and drop a screenshot of the UI you want to convert to Flutter.\n'
          'It can be from a real app, a design, or even a drawing!',
    ),
    _HowItWorksItem(
      title: 'Additional instructions',
      content: 'Optionally, add some extra instructions to help the AI generate the code.\n'
          'For example, how the UI should behave when the user interacts with it.',
    ),
    _HowItWorksItem(
      title: 'Code generation',
      content: 'The app leverages the power of OpenAI GPT-4o multimodal LLM to '
          'transform your screenshot and instructions into Flutter code.',
    ),
    _HowItWorksItem(
      title: 'Run the code',
      content: 'The generated code is stored in a GitHub Gist and loaded into DartPad.\n'
          'So you can run the resulting Flutter app right from the browser!',
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        color: theme.colorScheme.surface,
        margin: const EdgeInsets.only(top: 36),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1080),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How does it work?',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (final context, final constraints) {
                    final steps = Align(
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (final context, final index) {
                            return _HowItWorksItemWidget(
                              step: index + 1,
                              item: _items[index],
                            );
                          },
                          itemCount: _items.length,
                        ),
                      ),
                    );
                    final illustration = Assets.howItWorks.svg(width: 250);
                    return constraints.maxWidth > 768
                        ? Row(
                            children: [
                              Expanded(child: steps),
                              const SizedBox(width: 64),
                              illustration,
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              steps,
                              const SizedBox(height: 32),
                              illustration,
                            ],
                          );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HowItWorksItem {
  const _HowItWorksItem({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;
}

class _HowItWorksItemWidget extends StatelessWidget {
  const _HowItWorksItemWidget({
    required this.step,
    required this.item,
  });

  final int step;
  final _HowItWorksItem item;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                item.title,
                style: theme.textTheme.titleLarge,
              ),
              Text(
                item.content,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
