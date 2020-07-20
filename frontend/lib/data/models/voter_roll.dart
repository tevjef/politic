import 'package:json_annotation/json_annotation.dart';

part 'voter_roll.g.dart';

@JsonSerializable(nullable: false)
class StatesResponse {
  final List<USState> states;
  StatesResponse({this.states});
  factory StatesResponse.fromJson(Map<String, dynamic> json) => _$StatesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StatesResponseToJson(this);
}

@JsonSerializable(nullable: false)
class USState {
  final String name;
  final String abbreviation;
  final List<FieldInputDescriptor> fields;
  USState({this.name, this.abbreviation, this.fields});

  factory USState.fromJson(Map<String, dynamic> json) => _$USStateFromJson(json);
  Map<String, dynamic> toJson() => _$USStateToJson(this);
}

@JsonSerializable(nullable: true)
class FieldInputDescriptor {
  final String inputType;
  final String key;
  final List<String> options;
  FieldInputDescriptor({this.inputType, this.key, this.options});

  factory FieldInputDescriptor.fromJson(Map<String, dynamic> json) => _$FieldInputDescriptorFromJson(json);
  Map<String, dynamic> toJson() => _$FieldInputDescriptorToJson(this);
}

@JsonSerializable(nullable: false)
class EnrollmentRequest {
  final VoterInformation voterInformation;
  final String notificationToken;
  EnrollmentRequest({this.voterInformation, this.notificationToken});
  factory EnrollmentRequest.fromJson(Map<String, dynamic> json) => _$EnrollmentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollmentRequestToJson(this);
}

@JsonSerializable(nullable: false)
class CheckRegistrationRequest {
  final VoterInformation voterInformation;
  CheckRegistrationRequest({this.voterInformation});
  factory CheckRegistrationRequest.fromJson(Map<String, dynamic> json) => _$CheckRegistrationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CheckRegistrationRequestToJson(this);
}

@JsonSerializable(nullable: false)
class VoterInformation {
  final String state;
  final String firstName;
  final String lastName;
  final String middleInitial;
  final String month;
  final String county;
  final int year;

  VoterInformation({this.state, this.firstName, this.lastName, this.middleInitial, this.month, this.county, this.year});
  factory VoterInformation.fromJson(Map<String, dynamic> json) => _$VoterInformationFromJson(json);
  Map<String, dynamic> toJson() => _$VoterInformationToJson(this);
}

class CheckRegistrationResponse {
  final VoterStatus voterStatus;
  CheckRegistrationResponse({this.voterStatus});
  factory CheckRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      CheckRegistrationResponse(voterStatus: VoterStatus.fromJson(json["voterStatus"] as Map<String, dynamic>));
}

class VoterStatus {
  final String type;
  final VoterStatusType value;

  VoterStatus({this.type, this.value});
  factory VoterStatus.fromJson(Map<String, dynamic> json) => _$VoterStatusFromJson(json);
}

VoterStatus _$VoterStatusFromJson(Map<String, dynamic> json) {
  var type = json['type'] as String;

  switch (type) {
    case 'multipleEnrolled':
      {
        return VoterStatus(
            type: type,
            value: MultipleEnrolled(
                (json['value'] as List).map((e) => SingleEnrolled.fromJson(e as Map<String, dynamic>)).toList()));
      }
      break;
    case 'singleEnrolled':
      {
        return VoterStatus(
            type: type,
            value: SingleEnrolled(
                voterData: (json['value'] as List).map((e) => VoterData.fromJson(e as Map<String, dynamic>)).toList()));
      }
      break;
    case 'notEnrolled':
      {
        return VoterStatus(type: type, value: NotEnrolled.fromJson(json['value']));
      }
      break;
    case 'notFound':
      {
        return VoterStatus(type: type, value: NotFound.fromJson(json['value']));
      }
      break;
    default:
      {
        throw UnimplementedError("unknown types");
      }
      break;
  }
}

abstract class VoterStatusType {}

class MultipleEnrolled extends VoterStatusType {
  final List<SingleEnrolled> enrollments;
  MultipleEnrolled(this.enrollments);
}

@JsonSerializable(nullable: false)
class SingleEnrolled extends VoterStatusType {
  final List<VoterData> voterData;

  SingleEnrolled({this.voterData});
  factory SingleEnrolled.fromJson(Map<String, dynamic> json) => _$SingleEnrolledFromJson(json);
  Map<String, dynamic> toJson() => _$SingleEnrolledToJson(this);
}

@JsonSerializable(nullable: false)
class VoterData extends VoterStatusType {
  final String title;
  final String message;

  VoterData({this.title, this.message});
  factory VoterData.fromJson(Map<String, dynamic> json) => _$VoterDataFromJson(json);
  Map<String, dynamic> toJson() => _$VoterDataToJson(this);
}

@JsonSerializable(nullable: false)
class NotEnrolled extends VoterStatusType {
  final Deeplink phone;
  final String requirements;
  final Deeplink registrationUrl;

  NotEnrolled({this.phone, this.requirements, this.registrationUrl});
  factory NotEnrolled.fromJson(Map<String, dynamic> json) => _$NotEnrolledFromJson(json);
  Map<String, dynamic> toJson() => _$NotEnrolledToJson(this);
}

@JsonSerializable(nullable: false)
class NotFound extends VoterStatusType {
  final Deeplink phone;
  final String requirements;
  final Deeplink registrationUrl;

  NotFound({this.phone, this.requirements, this.registrationUrl});
  factory NotFound.fromJson(Map<String, dynamic> json) => _$NotFoundFromJson(json);
  Map<String, dynamic> toJson() => _$NotFoundToJson(this);
}

@JsonSerializable(nullable: false)
class Deeplink extends VoterStatusType {
  final String label;
  final String uri;

  Deeplink({this.label, this.uri});
  factory Deeplink.fromJson(Map<String, dynamic> json) => _$DeeplinkFromJson(json);
  Map<String, dynamic> toJson() => _$DeeplinkToJson(this);
}