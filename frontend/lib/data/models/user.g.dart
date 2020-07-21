// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdateRequest _$LocationUpdateRequestFromJson(
    Map<String, dynamic> json) {
  return LocationUpdateRequest(
    locationUpdate:
        LocationLatLng.fromJson(json['locationUpdate'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocationUpdateRequestToJson(
        LocationUpdateRequest instance) =>
    <String, dynamic>{
      'locationUpdate': instance.locationUpdate,
    };

LocationLatLng _$LocationLatLngFromJson(Map<String, dynamic> json) {
  return LocationLatLng(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
  );
}

Map<String, dynamic> _$LocationLatLngToJson(LocationLatLng instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

GetLocationResponse _$GetLocationResponseFromJson(Map<String, dynamic> json) {
  return GetLocationResponse(
    location:
        DistrictLocation.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetLocationResponseToJson(
        GetLocationResponse instance) =>
    <String, dynamic>{
      'location': instance.location,
    };

LocationUpdateResponse _$LocationUpdateResponseFromJson(
    Map<String, dynamic> json) {
  return LocationUpdateResponse(
    location:
        DistrictLocation.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LocationUpdateResponseToJson(
        LocationUpdateResponse instance) =>
    <String, dynamic>{
      'location': instance.location,
    };

DistrictLocation _$DistrictLocationFromJson(Map<String, dynamic> json) {
  return DistrictLocation(
    state: json['state'] as String,
    zipcode: json['zipcode'] as String,
    legislativeDistrict: json['legislativeDistrict'] as String,
    congressionalDistrict: json['congressionalDistrict'] as String,
  );
}

Map<String, dynamic> _$DistrictLocationToJson(DistrictLocation instance) =>
    <String, dynamic>{
      'state': instance.state,
      'zipcode': instance.zipcode,
      'legislativeDistrict': instance.legislativeDistrict,
      'congressionalDistrict': instance.congressionalDistrict,
    };
