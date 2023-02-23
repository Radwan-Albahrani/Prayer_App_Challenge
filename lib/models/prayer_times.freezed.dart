// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_times.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PrayerTimes _$PrayerTimesFromJson(Map<String, dynamic> json) {
  return _PrayerTimes.fromJson(json);
}

/// @nodoc
mixin _$PrayerTimes {
  @JsonKey(name: 'date')
  Map<String, dynamic> get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'timings')
  Map<String, dynamic> get timings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrayerTimesCopyWith<PrayerTimes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerTimesCopyWith<$Res> {
  factory $PrayerTimesCopyWith(
          PrayerTimes value, $Res Function(PrayerTimes) then) =
      _$PrayerTimesCopyWithImpl<$Res, PrayerTimes>;
  @useResult
  $Res call(
      {@JsonKey(name: 'date') Map<String, dynamic> date,
      @JsonKey(name: 'timings') Map<String, dynamic> timings});
}

/// @nodoc
class _$PrayerTimesCopyWithImpl<$Res, $Val extends PrayerTimes>
    implements $PrayerTimesCopyWith<$Res> {
  _$PrayerTimesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? timings = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timings: null == timings
          ? _value.timings
          : timings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PrayerTimesCopyWith<$Res>
    implements $PrayerTimesCopyWith<$Res> {
  factory _$$_PrayerTimesCopyWith(
          _$_PrayerTimes value, $Res Function(_$_PrayerTimes) then) =
      __$$_PrayerTimesCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'date') Map<String, dynamic> date,
      @JsonKey(name: 'timings') Map<String, dynamic> timings});
}

/// @nodoc
class __$$_PrayerTimesCopyWithImpl<$Res>
    extends _$PrayerTimesCopyWithImpl<$Res, _$_PrayerTimes>
    implements _$$_PrayerTimesCopyWith<$Res> {
  __$$_PrayerTimesCopyWithImpl(
      _$_PrayerTimes _value, $Res Function(_$_PrayerTimes) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? timings = null,
  }) {
    return _then(_$_PrayerTimes(
      date: null == date
          ? _value._date
          : date // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timings: null == timings
          ? _value._timings
          : timings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PrayerTimes implements _PrayerTimes {
  _$_PrayerTimes(
      {@JsonKey(name: 'date') required final Map<String, dynamic> date,
      @JsonKey(name: 'timings') required final Map<String, dynamic> timings})
      : _date = date,
        _timings = timings;

  factory _$_PrayerTimes.fromJson(Map<String, dynamic> json) =>
      _$$_PrayerTimesFromJson(json);

  final Map<String, dynamic> _date;
  @override
  @JsonKey(name: 'date')
  Map<String, dynamic> get date {
    if (_date is EqualUnmodifiableMapView) return _date;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_date);
  }

  final Map<String, dynamic> _timings;
  @override
  @JsonKey(name: 'timings')
  Map<String, dynamic> get timings {
    if (_timings is EqualUnmodifiableMapView) return _timings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timings);
  }

  @override
  String toString() {
    return 'PrayerTimes(date: $date, timings: $timings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PrayerTimes &&
            const DeepCollectionEquality().equals(other._date, _date) &&
            const DeepCollectionEquality().equals(other._timings, _timings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_date),
      const DeepCollectionEquality().hash(_timings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrayerTimesCopyWith<_$_PrayerTimes> get copyWith =>
      __$$_PrayerTimesCopyWithImpl<_$_PrayerTimes>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PrayerTimesToJson(
      this,
    );
  }
}

abstract class _PrayerTimes implements PrayerTimes {
  factory _PrayerTimes(
      {@JsonKey(name: 'date')
          required final Map<String, dynamic> date,
      @JsonKey(name: 'timings')
          required final Map<String, dynamic> timings}) = _$_PrayerTimes;

  factory _PrayerTimes.fromJson(Map<String, dynamic> json) =
      _$_PrayerTimes.fromJson;

  @override
  @JsonKey(name: 'date')
  Map<String, dynamic> get date;
  @override
  @JsonKey(name: 'timings')
  Map<String, dynamic> get timings;
  @override
  @JsonKey(ignore: true)
  _$$_PrayerTimesCopyWith<_$_PrayerTimes> get copyWith =>
      throw _privateConstructorUsedError;
}
