// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatesResponse _$StatesResponseFromJson(Map<String, dynamic> json) {
  return StatesResponse(
    states: (json['states'] as List)
        .map((e) => State.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StatesResponseToJson(StatesResponse instance) =>
    <String, dynamic>{
      'states': instance.states,
    };

State _$StateFromJson(Map<String, dynamic> json) {
  return State(
    name: json['name'] as String,
    abbreviation: json['abbreviation'] as String,
    fields: (json['fields'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'fields': instance.fields,
    };
