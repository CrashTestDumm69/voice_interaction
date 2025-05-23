// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthPackage {

 String get package; int get price; List<String> get tests; List<String> get consultations; String get description;
/// Create a copy of HealthPackage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthPackageCopyWith<HealthPackage> get copyWith => _$HealthPackageCopyWithImpl<HealthPackage>(this as HealthPackage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthPackage&&(identical(other.package, package) || other.package == package)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.tests, tests)&&const DeepCollectionEquality().equals(other.consultations, consultations)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,package,price,const DeepCollectionEquality().hash(tests),const DeepCollectionEquality().hash(consultations),description);



}

/// @nodoc
abstract mixin class $HealthPackageCopyWith<$Res>  {
  factory $HealthPackageCopyWith(HealthPackage value, $Res Function(HealthPackage) _then) = _$HealthPackageCopyWithImpl;
@useResult
$Res call({
 String package, int price, List<String> tests, List<String> consultations, String description
});




}
/// @nodoc
class _$HealthPackageCopyWithImpl<$Res>
    implements $HealthPackageCopyWith<$Res> {
  _$HealthPackageCopyWithImpl(this._self, this._then);

  final HealthPackage _self;
  final $Res Function(HealthPackage) _then;

/// Create a copy of HealthPackage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? package = null,Object? price = null,Object? tests = null,Object? consultations = null,Object? description = null,}) {
  return _then(HealthPackage(
package: null == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,tests: null == tests ? _self.tests : tests // ignore: cast_nullable_to_non_nullable
as List<String>,consultations: null == consultations ? _self.consultations : consultations // ignore: cast_nullable_to_non_nullable
as List<String>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


// dart format on
