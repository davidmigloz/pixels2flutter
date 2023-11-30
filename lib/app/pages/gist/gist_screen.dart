// ignore_for_file: avoid_web_libraries_in_flutter, unsafe_html
import 'dart:html';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection/injection.dart';
import 'bloc/gist_screen_cubit.dart';

class GistScreen extends StatelessWidget {
  const GistScreen({
    super.key,
    required this.gistId,
  });

  final String gistId;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (final _) => getIt<GistScreenCubit>(param1: gistId),
      child: const _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold();

  @override
  Widget build(final BuildContext context) {
    final cubit = context.read<GistScreenCubit>();
    return Scaffold(
      body: const _Body(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: cubit.onDeleteGistPressed,
            tooltip: 'Delete Gist',
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(final BuildContext context) {
    final cubit = context.read<GistScreenCubit>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 0.9,
          colors: [
            Color(0xFF5877F5),
            Color(0xFF023379),
          ],
        ),
      ),
      child: _IframeView(url: cubit.state.dartpadUrl),
    );
  }
}

class _IframeView extends StatefulWidget {
  const _IframeView({required this.url});

  final String url;

  @override
  State<_IframeView> createState() => _IframeViewState();
}

class _IframeViewState extends State<_IframeView> {
  final _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();
    _iframeElement
      ..src = widget.url
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';
    ui_web.platformViewRegistry.registerViewFactory(
      widget.url,
      (final int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return HtmlElementView(
      key: UniqueKey(),
      viewType: widget.url,
    );
  }
}
