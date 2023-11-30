part of 'gist_screen_cubit.dart';

@immutable
class GistScreenState extends Equatable {
  const GistScreenState({
    this.status = GistScreenStatus.idle,
    required this.gistId,
  });

  final GistScreenStatus status;
  final String gistId;

  String get dartpadUrl => Uri(
        scheme: 'https',
        host: 'dartpad.dev',
        queryParameters: {
          'id': gistId,
          'run': 'true',
        },
      ).toString();

  GistScreenState copyWith({
    final GistScreenStatus? status,
    final String? gistId,
  }) {
    return GistScreenState(
      status: status ?? this.status,
      gistId: gistId ?? this.gistId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        gistId,
      ];
}

enum GistScreenStatus {
  idle,
}
