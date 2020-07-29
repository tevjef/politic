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
class StateFeedItem {
  final String itemType;
  final String title;
  final String link;
  StateFeedItem({this.itemType, this.title, this.link});
  factory StateFeedItem.fromJson(Map<String, dynamic> json) => _$StateFeedItemFromJson(json);
  Map<String, dynamic> toJson() => _$StateFeedItemToJson(this);
}

@JsonSerializable(nullable: true)
class StateRepresentative {
  final String displayName;
  final String image;
  final String bioguide;
  final String description;
  StateRepresentative({this.displayName, this.image, this.description, this.bioguide});
  factory StateRepresentative.fromJson(Map<String, dynamic> json) => _$StateRepresentativeFromJson(json);
  Map<String, dynamic> toJson() => _$StateRepresentativeToJson(this);
}

class RepresentativesResponse {
  List<StateRepresentative> senators;
  Representatives representative;
  List<Local> local;

  RepresentativesResponse({this.senators, this.representative, this.local});

  RepresentativesResponse.fromJson(Map<String, dynamic> json) {
    if (json['senators'] != null) {
      senators = new List<StateRepresentative>();
      json['senators'].forEach((v) {
        senators.add(new StateRepresentative.fromJson(v));
      });
    }
    representative = json['representative'] != null ? new Representatives.fromJson(json['representative']) : null;
    if (json['local'] != null) {
      local = new List<Local>();
      json['local'].forEach((v) {
        local.add(new Local.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.senators != null) {
      data['senators'] = this.senators.map((v) => v.toJson()).toList();
    }
    if (this.representative != null) {
      data['representative'] = this.representative;
    }
    if (this.local != null) {
      data['local'] = this.local.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Senators {
  String displayName;
  String image;
  String description;

  Senators({this.displayName, this.image, this.description});

  Senators.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}

class Representatives {
  StateRepresentative localRepresentative;

  Representatives({this.localRepresentative});

  Representatives.fromJson(Map<String, dynamic> json) {
    if (json['localRepresentative'] != null) {
      localRepresentative = new StateRepresentative.fromJson(json['localRepresentative']);
    }
  }
}

class Local {
  String officeTitle;
  List<StateRepresentative> officials;

  Local({this.officeTitle, this.officials});

  Local.fromJson(Map<String, dynamic> json) {
    officeTitle = json['officeTitle'];
    if (json['officials'] != null) {
      officials = new List<StateRepresentative>();
      json['officials'].forEach((v) {
        officials.add(new StateRepresentative.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['officeTitle'] = this.officeTitle;
    if (this.officials != null) {
      data['officials'] = this.officials.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ElectionResponse {
  Election election;

  ElectionResponse({this.election});

  ElectionResponse.fromJson(Map<String, dynamic> json) {
    election = json['election'] != null ? new Election.fromJson(json['election']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.election != null) {
      data['election'] = this.election.toJson();
    }
    return data;
  }
}

class Election {
  String electionsName;
  String electionDay;
  List<PollingLocation> pollingLocations;
  List<PollingLocation> earlyVoteSites;
  List<PollingLocation> dropOffLocations;
  ElectionAdministrationBody electionAdministrationBody;
  List<Contest> contests;

  Election(
      {this.electionsName,
      this.electionDay,
      this.pollingLocations,
      this.earlyVoteSites,
      this.dropOffLocations,
      this.electionAdministrationBody,
      this.contests});

  Election.fromJson(Map<String, dynamic> json) {
    electionsName = json['electionsName'];
    electionDay = json['electionDay'];
    if (json['pollingLocations'] != null) {
      pollingLocations = new List<PollingLocation>();
      json['pollingLocations'].forEach((v) {
        pollingLocations.add(new PollingLocation.fromJson(v));
      });
    }
    if (json['earlyVoteSites'] != null) {
      earlyVoteSites = new List<PollingLocation>();
      json['earlyVoteSites'].forEach((v) {
        earlyVoteSites.add(new PollingLocation.fromJson(v));
      });
    }
    if (json['dropOffLocations'] != null) {
      dropOffLocations = new List<PollingLocation>();
      json['dropOffLocations'].forEach((v) {
        dropOffLocations.add(new PollingLocation.fromJson(v));
      });
    }
    electionAdministrationBody = json['electionAdministrationBody'] != null
        ? new ElectionAdministrationBody.fromJson(json['electionAdministrationBody'])
        : null;
    if (json['contests'] != null) {
      contests = new List<Contest>();
      json['contests'].forEach((v) {
        contests.add(new Contest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['electionsName'] = this.electionsName;
    data['electionDay'] = this.electionDay;
    if (this.pollingLocations != null) {
      data['pollingLocations'] = this.pollingLocations.map((v) => v.toJson()).toList();
    }
    if (this.earlyVoteSites != null) {
      data['earlyVoteSites'] = this.earlyVoteSites.map((v) => v.toJson()).toList();
    }
    if (this.dropOffLocations != null) {
      data['dropOffLocations'] = this.dropOffLocations.map((v) => v.toJson()).toList();
    }
    if (this.electionAdministrationBody != null) {
      data['electionAdministrationBody'] = this.electionAdministrationBody.toJson();
    }
    if (this.contests != null) {
      data['contests'] = this.contests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PollingLocation {
  String locationName;
  String address;

  PollingLocation({this.locationName, this.address});

  PollingLocation.fromJson(Map<String, dynamic> json) {
    locationName = json['locationName'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationName'] = this.locationName;
    data['address'] = this.address;
    return data;
  }
}

class ElectionAdministrationBody {
  String name;
  ElectionInfoUrl electionInfoUrl;

  ElectionAdministrationBody({this.name, this.electionInfoUrl});

  ElectionAdministrationBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    electionInfoUrl = json['electionInfoUrl'] != null ? new ElectionInfoUrl.fromJson(json['electionInfoUrl']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.electionInfoUrl != null) {
      data['electionInfoUrl'] = this.electionInfoUrl.toJson();
    }
    return data;
  }
}

class ElectionInfoUrl {
  String label;
  String uri;

  ElectionInfoUrl({this.label, this.uri});

  ElectionInfoUrl.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['uri'] = this.uri;
    return data;
  }
}

class Contest {
  String title;
  String subtitle;
  List<Candidate> candidates;

  Contest({this.title, this.subtitle, this.candidates});

  Contest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    if (json['candidates'] != null) {
      candidates = new List<Candidate>();
      json['candidates'].forEach((v) {
        candidates.add(new Candidate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    if (this.candidates != null) {
      data['candidates'] = this.candidates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Candidate {
  String name;
  String party;

  Candidate({this.name, this.party});

  Candidate.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    party = json['party'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['party'] = this.party;
    return data;
  }
}

class ElectionsResponse {
  List<Election> elections;

  ElectionsResponse({this.elections});

  ElectionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['elections'] != null) {
      elections = new List<Election>();
      json['elections'].forEach((v) {
        elections.add(new Election.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.elections != null) {
      data['elections'] = this.elections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
