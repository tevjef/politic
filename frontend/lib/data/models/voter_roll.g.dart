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
    fields: (json['fields'] as List)
        .map((e) => FieldInputDescriptor.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$USStateToJson(USState instance) => <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'fields': instance.fields,
    };

FieldInputDescriptor _$FieldInputDescriptorFromJson(Map<String, dynamic> json) {
  return FieldInputDescriptor(
    inputType: json['inputType'] as String,
    key: json['key'] as String,
    options: (json['options'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$FieldInputDescriptorToJson(
        FieldInputDescriptor instance) =>
    <String, dynamic>{
      'inputType': instance.inputType,
      'key': instance.key,
      'options': instance.options,
    };

EnrollmentRequest _$EnrollmentRequestFromJson(Map<String, dynamic> json) {
  return EnrollmentRequest(
    enrollment: Enrollment.fromJson(json['enrollment'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EnrollmentRequestToJson(EnrollmentRequest instance) =>
    <String, dynamic>{
      'enrollment': instance.enrollment,
    };

Enrollment _$EnrollmentFromJson(Map<String, dynamic> json) {
  return Enrollment(
    voterInformation: VoterInformation.fromJson(
        json['voterInformation'] as Map<String, dynamic>),
    notificationToken: json['notificationToken'] as String,
  );
}

Map<String, dynamic> _$EnrollmentToJson(Enrollment instance) =>
    <String, dynamic>{
      'voterInformation': instance.voterInformation,
      'notificationToken': instance.notificationToken,
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
      'voterInformation': instance.voterInformation,
    };

VoterInformation _$VoterInformationFromJson(Map<String, dynamic> json) {
  return VoterInformation(
    state: json['state'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    middleInitial: json['middleInitial'] as String,
    month: json['month'] as String,
    county: json['county'] as String,
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
      'county': instance.county,
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

NotEnrolled _$NotEnrolledFromJson(Map<String, dynamic> json) {
  return NotEnrolled(
    phone: Deeplink.fromJson(json['phone'] as Map<String, dynamic>),
    requirements: json['requirements'] as String,
    registrationUrl:
        Deeplink.fromJson(json['registrationUrl'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotEnrolledToJson(NotEnrolled instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'requirements': instance.requirements,
      'registrationUrl': instance.registrationUrl,
    };

NotFound _$NotFoundFromJson(Map<String, dynamic> json) {
  return NotFound(
    phone: Deeplink.fromJson(json['phone'] as Map<String, dynamic>),
    requirements: json['requirements'] as String,
    registrationUrl:
        Deeplink.fromJson(json['registrationUrl'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotFoundToJson(NotFound instance) => <String, dynamic>{
      'phone': instance.phone,
      'requirements': instance.requirements,
      'registrationUrl': instance.registrationUrl,
    };

Deeplink _$DeeplinkFromJson(Map<String, dynamic> json) {
  return Deeplink(
    label: json['label'] as String,
    uri: json['uri'] as String,
  );
}

Map<String, dynamic> _$DeeplinkToJson(Deeplink instance) => <String, dynamic>{
      'label': instance.label,
      'uri': instance.uri,
    };
