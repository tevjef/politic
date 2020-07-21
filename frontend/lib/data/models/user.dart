import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class LocationUpdateRequest {
  final LocationLatLng locationUpdate;
  LocationUpdateRequest({this.locationUpdate});
  factory LocationUpdateRequest.fromJson(Map<String, dynamic> json) => _$LocationUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateRequestToJson(this);
}

@JsonSerializable(nullable: false)
class LocationLatLng {
  final double lat;
  final double lng;
  LocationLatLng({this.lat, this.lng});
  factory LocationLatLng.fromJson(Map<String, dynamic> json) => _$LocationLatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LocationLatLngToJson(this);
}

@JsonSerializable(nullable: false)
class GetLocationResponse {
  final DistrictLocation location;
  GetLocationResponse({this.location});
  factory GetLocationResponse.fromJson(Map<String, dynamic> json) => _$GetLocationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetLocationResponseToJson(this);
}

@JsonSerializable(nullable: false)
class LocationUpdateResponse {
  final DistrictLocation location;
  LocationUpdateResponse({this.location});
  factory LocationUpdateResponse.fromJson(Map<String, dynamic> json) => _$LocationUpdateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateResponseToJson(this);
}

@JsonSerializable(nullable: false)
class DistrictLocation {
  final String state;
  final String zipcode;
  final String legislativeDistrict;
  final String congressionalDistrict;
  DistrictLocation({this.state, this.zipcode, this.legislativeDistrict, this.congressionalDistrict});
  factory DistrictLocation.fromJson(Map<String, dynamic> json) => _$DistrictLocationFromJson(json);
  Map<String, dynamic> toJson() => _$DistrictLocationToJson(this);
}
