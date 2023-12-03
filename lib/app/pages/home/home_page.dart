import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../assets/assets.gen.dart';
import '../../injection/injection.dart';
import 'bloc/home_page_cubit.dart';
import 'home_page_app.dart';
import 'home_page_examples.dart';
import 'home_page_faqs.dart';
import 'home_page_how_it_works.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (final _) => getIt<HomePageCubit>(),
      child: const _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold();

  @override
  Widget build(final BuildContext context) {
    return BlocListener<HomePageCubit, HomePageState>(
      child: const SelectionArea(
        child: Scaffold(
          body: _Body(),
        ),
      ),
      listenWhen: (final previous, final current) => previous.generateCodeError != current.generateCodeError,
      listener: (final context, final state) {
        if (state.generateCodeError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error generating code. Please try again.')),
          );
        }
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(final BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 0.9,
          colors: [
            Color(0xFF5877F5),
            Color(0xFF023379),
          ],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          _Logo(),
          HomePageAppSection(),
          HomePageHowItWorksSection(),
          HomePageExamplesSection(),
          HomePageFAQsSection(),
          _Footer(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                hoverColor: theme.colorScheme.surfaceTint,
                onPressed: () async {
                  await launchUrl(
                    Uri.parse('https://github.com/davidmigloz/pixels2flutter'),
                  );
                },
                icon: Opacity(
                  opacity: 0.9,
                  child: Assets.github.svg(
                    height: 36,
                  ),
                ),
              ),
            ),
          ),
          Assets.pixels2flutter
              .svg(height: 230)
              .animate(delay: 500.ms) //
              .fadeIn(
                duration: 500.ms,
                curve: Curves.easeIn,
              ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Made with 💙 by David Miguel
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Made with ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Icon(
                      Icons.favorite,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ).animate(onPlay: (final c) => c.loop()).shimmer(
                          delay: 500.ms,
                          duration: 2000.ms,
                          color: theme.colorScheme.secondary,
                        ),
                    Text(
                      ' by ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Link(
                      uri: Uri.parse('https://www.linkedin.com/in/davidmigloz'),
                      target: LinkTarget.blank,
                      builder: (final context, final followLink) => InkWell(
                        onTap: followLink,
                        child: Text(
                          'David Miguel',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Flutter and the related logo are trademarks of Google LLC. We are not endorsed by or affiliated with Google LLC.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
