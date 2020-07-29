export interface Election {
  id: string;
  name: string;
  electionDay: string;
  ocdDivisionId: string;
}

export interface NormalizedInput {
  line1: string;
  city: string;
  state: string;
  zip: string;
}

export interface Address {
  locationName: string;
  line1: string;
  city: string;
  state: string;
  zip: string;
}

export interface Source {
  name: string;
  official: boolean;
}

export interface PollingLocation {
  address: Address;
  sources: Source[];
}

export interface District {
  name: string;
  scope: string;
}

export interface Source2 {
  name: string;
  official: boolean;
}

export interface Candidate {
  name: string;
  party: string;
}

export interface Contest {
  type: string;
  primaryParties: string[];
  primaryParty: string;
  office: string;
  district: District;
  ballotPlacement: string;
  sources: Source2[];
  candidates: Candidate[];
  level: string[];
}

export interface PhysicalAddress {
  locationName: string;
  line1: string;
  line2: string;
  line3: string;
  city: string;
  state: string;
  zip: string;
}

export interface ElectionAdministrationBody {
  name: string;
  electionInfoUrl: string;
  electionRegistrationUrl: string;
  electionRegistrationConfirmationUrl: string;
  absenteeVotingInfoUrl: string;
  votingLocationFinderUrl: string;
  ballotInfoUrl: string;
  electionRulesUrl: string;
  physicalAddress: PhysicalAddress;
}

export interface ElectionOfficial {
  officePhoneNumber: string;
  faxNumber: string;
}

export interface Source3 {
  name: string;
  official: boolean;
}

export interface LocalJurisdiction {
  name: string;
  electionAdministrationBody: ElectionAdministrationBody;
  sources: Source3[];
}

export interface Source4 {
  name: string;
  official: boolean;
}

export interface State {
  name: string;
  electionAdministrationBody: ElectionAdministrationBody;
  local_jurisdiction: LocalJurisdiction;
  sources: Source4[];
}

export interface GoogleVoterInfoResponse {
  election: Election;
  pollingLocations?: PollingLocation[];
  earlyVoteSites?: PollingLocation[];
  dropOffLocations?: PollingLocation[];
  contests?: Contest[];
  state: State[];
}

 export interface Election {
   id: string;
   name: string;
   electionDay: string;
   ocdDivisionId: string;
 }

 export interface GoogleElectionsResponse {
   elections: Election[];
 }