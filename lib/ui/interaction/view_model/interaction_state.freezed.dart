// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InteractionState {

 RealtimeConnectionState get connectionState; SpeechState get speechState; HealthPackage? get packageDetails; bool get isMicMuted;
/// Create a copy of InteractionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InteractionStateCopyWith<InteractionState> get copyWith => _$InteractionStateCopyWithImpl<InteractionState>(this as InteractionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InteractionState&&(identical(other.connectionState, connectionState) || other.connectionState == connectionState)&&(identical(other.speechState, speechState) || other.speechState == speechState)&&(identical(other.packageDetails, packageDetails) || other.packageDetails == packageDetails)&&(identical(other.isMicMuted, isMicMuted) || other.isMicMuted == isMicMuted));
}


@override
int get hashCode => Object.hash(runtimeType,connectionState,speechState,packageDetails,isMicMuted);

@override
String toString() {
  return 'InteractionState(connectionState: $connectionState, speechState: $speechState, packageDetails: $packageDetails, isMicMuted: $isMicMuted)';
}


}

/// @nodoc
abstract mixin class $InteractionStateCopyWith<$Res>  {
  factory $InteractionStateCopyWith(InteractionState value, $Res Function(InteractionState) _then) = _$InteractionStateCopyWithImpl;
@useResult
$Res call({
 RealtimeConnectionState connectionState, SpeechState speechState, HealthPackage? packageDetails, bool isMicMuted
});




}
/// @nodoc
class _$InteractionStateCopyWithImpl<$Res>
    implements $InteractionStateCopyWith<$Res> {
  _$InteractionStateCopyWithImpl(this._self, this._then);

  final InteractionState _self;
  final $Res Function(InteractionState) _then;

/// Create a copy of InteractionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectionState = null,Object? speechState = null,Object? packageDetails = freezed,Object? isMicMuted = null,}) {
  return _then(InteractionState(
connectionState: null == connectionState ? _self.connectionState : connectionState // ignore: cast_nullable_to_non_nullable
as RealtimeConnectionState,speechState: null == speechState ? _self.speechState : speechState // ignore: cast_nullable_to_non_nullable
as SpeechState,packageDetails: freezed == packageDetails ? _self.packageDetails : packageDetails // ignore: cast_nullable_to_non_nullable
as HealthPackage?,isMicMuted: null == isMicMuted ? _self.isMicMuted : isMicMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


// dart format on
