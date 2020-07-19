export interface Id {
  bioguide: string;
  thomas: string;
  lis: string;
  govtrack: number;
  opensecrets: string;
  votesmart: number;
  fec: string[];
  cspan: number;
  wikipedia: string;
  house_history: number;
  ballotpedia: string;
  maplight: number;
  icpsr: number;
  wikidata: string;
  google_entity_id: string;
}

export interface Name {
  first: string;
  last: string;
  official_full: string;
}

export interface Bio {
  birthday: string;
  gender: string;
}

export interface Term {
  type: string;
  start: string;
  end: string;
  state: string;
  district: number;
  party: string;
  url: string;
  class?: number;
  address: string;
  phone: string;
  fax: string;
  contact_form: string;
  office: string;
  state_rank: string;
  rss_url: string;
}

export interface Legislator {
  id: Id;
  name: Name;
  bio: Bio;
  terms: Term[];
}
