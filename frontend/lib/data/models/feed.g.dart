// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateFeedResponse _$StateFeedResponseFromJson(Map<String, dynamic> json) {
  return StateFeedResponse(
    feed: (json['feed'] as List)
        .map((e) => StateFeedItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    representatives: (json['representatives'] as List)
        .map((e) => StateRepresentative.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StateFeedResponseToJson(StateFeedResponse instance) =>
    <String, dynamic>{
      'feed': instance.feed,
      'representatives': instance.representatives,
    };

StateFeedItem _$StateFeedItemFromJson(Map<String, dynamic> json) {
  return StateFeedItem(
    itemType: json['itemType'] as String,
    title: json['title'] as String,
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$StateFeedItemToJson(StateFeedItem instance) =>
    <String, dynamic>{
      'itemType': instance.itemType,
      'title': instance.title,
      'link': instance.link,
    };

StateRepresentative _$StateRepresentativeFromJson(Map<String, dynamic> json) {
  return StateRepresentative(
    displayName: json['displayName'] as String,
    image: json['image'] as String,
    bioguide: json['bioguide'] as String,
  );
}

Map<String, dynamic> _$StateRepresentativeToJson(
        StateRepresentative instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'image': instance.image,
      'bioguide': instance.bioguide,
    };
