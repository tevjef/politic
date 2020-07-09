import 'package:json_annotation/json_annotation.dart';

part 'states_response.g.dart';

@JsonSerializable(nullable: false)
class StatesResponse {
  final List<State> states;
  StatesResponse({this.states});
  factory StatesResponse.fromJson(Map<String, dynamic> json) => _$StatesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StatesResponseToJson(this);
}

@JsonSerializable(nullable: false)
class State {
  final String name;
  final String abbreviation;
  final List<String> fields;
  State({this.name, this.abbreviation, this.fields});

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);
  Map<String, dynamic> toJson() => _$StateToJson(this);
}