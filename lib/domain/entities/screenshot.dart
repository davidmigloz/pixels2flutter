part of 'entities.dart';

@freezed
class Screenshot with _$Screenshot {
  const factory Screenshot({
    required final String mimeType,
    required final Uint8List data,
  }) = _Screenshot;
}
