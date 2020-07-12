// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voter_roll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatesResponse _$StatesResponseFromJson(Map<String, dynamic> json) {
  return StatesResponse(
    states: (json['states'] as List)
        .map((e) => USState.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StatesResponseToJson(StatesResponse instance) =>
    <String, dynamic>{
      'states': instance.states,
    };

USState _$USStateFromJson(Map<String, dynamic> json) {
  return USState(
    name: json['name'] as String,
    abbreviation: json['abbreviation'] as String,
    fields: (json['fields'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$USStateToJson(USState instance) => <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'fields': instance.fields,
    };

CheckRegistrationRequest _$CheckRegistrationRequestFromJson(
    Map<String, dynamic> json) {
  return CheckRegistrationRequest(
    voterInformation: VoterInformation.fromJson(
        json['voterInformation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CheckRegistrationRequestToJson(
        CheckRegistrationRequest instance) =>
    <String, dynamic>{
      'voterInformation': instance.voterInformation.toJson(),
    };

VoterInformation _$VoterInformationFromJson(Map<String, dynamic> json) {
  return VoterInformation(
    state: json['state'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    middleInitial: json['middleInitial'] as String,
    month: json['month'] as String,
    year: json['year'] as int,
  );
}

Map<String, dynamic> _$VoterInformationToJson(VoterInformation instance) =>
    <String, dynamic>{
      'state': instance.state,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleInitial': instance.middleInitial,
      'month': instance.month,
      'year': instance.year,
    };

SingleEnrolled _$SingleEnrolledFromJson(Map<String, dynamic> json) {
  return SingleEnrolled(
    voterData: (json['voterData'] as List)
        .map((e) => VoterData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SingleEnrolledToJson(SingleEnrolled instance) =>
    <String, dynamic>{
      'voterData': instance.voterData,
    };

VoterData _$VoterDataFromJson(Map<String, dynamic> json) {
  return VoterData(
    title: json['title'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$VoterDataToJson(VoterData instance) => <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
    };

NotEnrolled _$NotEntrolledFromJson(Map<String, dynamic> json) {
  return NotEnrolled(
    requirements: json['requirements'] as String,
    registrationUrl: json['registrationUrl'] as String,
  );
}

Map<String, dynamic> _$NotEntrolledToJson(NotEnrolled instance) =>
    <String, dynamic>{
      'requirements': instance.requirements,
      'registrationUrl': instance.registrationUrl,
    };

NotFound _$NotFoundFromJson(Map<String, dynamic> json) {
  return NotFound(
    phone: json['phone'] as String,
    web: json['web'] as String,
  );
}

Map<String, dynamic> _$NotFoundToJson(NotFound instance) => <String, dynamic>{
      'phone': instance.phone,
      'web': instance.web,
    };
