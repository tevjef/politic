import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

@JsonSerializable(nullable: false)
class StateFeedResponse {
  final List<StateFeedItem> feed;
  final List<StateRepresentative> representatives;
  StateFeedResponse({this.feed, this.representatives});
  factory StateFeedResponse.fromJson(Map<String, dynamic> json) => _$StateFeedResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StateFeedResponseToJson(this);
}

@JsonSerializable(nullable: false)
class StateFeedItem  {
  final String itemType;
  final String title;
  final String link;
  StateFeedItem({this.itemType, this.title, this.link});
  factory StateFeedItem.fromJson(Map<String, dynamic> json) => _$StateFeedItemFromJson(json);
  Map<String, dynamic> toJson() => _$StateFeedItemToJson(this);
}

@JsonSerializable(nullable: false)
class StateRepresentative  {
  final String displayName;
  final String image;
  final String bioguide;
  StateRepresentative({this.displayName, this.image, this.bioguide});
  factory StateRepresentative.fromJson(Map<String, dynamic> json) => _$StateRepresentativeFromJson(json);
  Map<String, dynamic> toJson() => _$StateRepresentativeToJson(this);
}
