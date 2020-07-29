import { Deeplink } from "./VoterRegistration";

export interface StateFeedResponse {
  feed: FeedItem[];
  representatives: FeedRepresentative[];
}

export interface FeedItem {
  itemType: FeedItemType;
  title: String;
  link: String;
}

export type FeedItemType = "keyVote" | "pressRelease";

export interface FeedRepresentative {
  displayName: string;
  image?: string;
  title: string;
  bioguide?: string;
  party: string;
  description?: string;
}

export interface LegislatorsResponse {
  senators: FeedRepresentative[];
  representative: Representatives;
  local: LocalRepresentative[];
}

export interface LocalRepresentative {
  officeTitle: string;
  officials: FeedRepresentative[];
}

export interface Representatives {
  localRepresentative: FeedRepresentative;
}


export interface PollingLocation {
  locationName: string;
  address: string;
}

export interface ElectionInfoUrl {
  label: string;
  uri: string;
}

export interface ElectionAdministrationBody {
  name: string;
  electionInfoUrl: Deeplink;
  electionRegistrationUrl?: Deeplink;
  absenteeVotingInfoUrl?: Deeplink;
  ballotInfoUrl?: Deeplink;
}

export interface District {
  name: string;
  scope: string;
}

export interface Candidate {
  name: string;
  party: string;
}

export interface Contest {
  title: string;
  subtitle: string;
  candidates: Candidate[];
}

export interface Election {
  electionName: string;
  electionDay: string;
  pollingLocations?: PollingLocation[];
  earlyVoteSites?: PollingLocation[];
  dropOffLocations?: PollingLocation[];
  electionAdministrationBody: ElectionAdministrationBody;
  contests?: Contest[];
}

export interface ElectionResponse {
  election?: Election;
}

export interface ElectionItem {
  id: string;
  electionName: string;
  electionDay: string;
}


export interface ElectionsResponse {
  elections: ElectionItem[];
}
