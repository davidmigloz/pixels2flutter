// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Screenshot {
  String get mimeType => throw _privateConstructorUsedError;
  Uint8List get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScreenshotCopyWith<Screenshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenshotCopyWith<$Res> {
  factory $ScreenshotCopyWith(
          Screenshot value, $Res Function(Screenshot) then) =
      _$ScreenshotCopyWithImpl<$Res, Screenshot>;
  @useResult
  $Res call({String mimeType, Uint8List data});
}

/// @nodoc
class _$ScreenshotCopyWithImpl<$Res, $Val extends Screenshot>
    implements $ScreenshotCopyWith<$Res> {
  _$ScreenshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mimeType = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScreenshotImplCopyWith<$Res>
    implements $ScreenshotCopyWith<$Res> {
  factory _$$ScreenshotImplCopyWith(
          _$ScreenshotImpl value, $Res Function(_$ScreenshotImpl) then) =
      __$$ScreenshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mimeType, Uint8List data});
}

/// @nodoc
class __$$ScreenshotImplCopyWithImpl<$Res>
    extends _$ScreenshotCopyWithImpl<$Res, _$ScreenshotImpl>
    implements _$$ScreenshotImplCopyWith<$Res> {
  __$$ScreenshotImplCopyWithImpl(
      _$ScreenshotImpl _value, $Res Function(_$ScreenshotImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mimeType = null,
    Object? data = null,
  }) {
    return _then(_$ScreenshotImpl(
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$ScreenshotImpl with DiagnosticableTreeMixin implements _Screenshot {
  const _$ScreenshotImpl({required this.mimeType, required this.data});

  @override
  final String mimeType;
  @override
  final Uint8List data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Screenshot(mimeType: $mimeType, data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Screenshot'))
      ..add(DiagnosticsProperty('mimeType', mimeType))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreenshotImpl &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScreenshotImplCopyWith<_$ScreenshotImpl> get copyWith =>
      __$$ScreenshotImplCopyWithImpl<_$ScreenshotImpl>(this, _$identity);
}

abstract class _Screenshot implements Screenshot {
  const factory _Screenshot(
      {required final String mimeType,
      required final Uint8List data}) = _$ScreenshotImpl;

  @override
  String get mimeType;
  @override
  Uint8List get data;
  @override
  @JsonKey(ignore: true)
  _$$ScreenshotImplCopyWith<_$ScreenshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
