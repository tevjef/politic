//
/* 
  {
    "id": {
      "bioguide": "B000944",
      "thomas": "00136",
      "lis": "S307",
      "govtrack": 400050,
      "opensecrets": "N00003535",
      "votesmart": 27018,
      "fec": [
        "H2OH13033",
        "S6OH00163"
      ],
      "cspan": 5051,
      "wikipedia": "Sherrod Brown",
      "house_history": 9996,
      "ballotpedia": "Sherrod Brown",
      "maplight": 168,
      "icpsr": 29389,
      "wikidata": "Q381880",
      "google_entity_id": "kg:/m/034s80"
    },
    "name": {
      "first": "Sherrod",
      "last": "Brown",
      "official_full": "Sherrod Brown"
    },
    "bio": {
      "birthday": "1952-11-09",
      "gender": "M"
    },
    "terms": [
      {
        "type": "rep",
        "start": "1993-01-05",
        "end": "1995-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat"
      },
      {
        "type": "rep",
        "start": "1995-01-04",
        "end": "1997-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat"
      },
      {
        "type": "rep",
        "start": "1997-01-07",
        "end": "1999-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat"
      },
      {
        "type": "rep",
        "start": "1999-01-06",
        "end": "2001-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat"
      },
      {
        "type": "rep",
        "start": "2001-01-03",
        "end": "2003-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat"
      },
      {
        "type": "rep",
        "start": "2003-01-07",
        "end": "2005-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat",
        "url": "http://www.house.gov/sherrodbrown"
      },
      {
        "type": "rep",
        "start": "2005-01-04",
        "end": "2007-01-03",
        "state": "OH",
        "district": 13,
        "party": "Democrat",
        "url": "http://www.house.gov/sherrodbrown"
      },
      {
        "type": "sen",
        "start": "2007-01-04",
        "end": "2013-01-03",
        "state": "OH",
        "class": 1,
        "party": "Democrat",
        "url": "http://brown.senate.gov/",
        "address": "713 HART SENATE OFFICE BUILDING WASHINGTON DC 20510",
        "phone": "202-224-2315",
        "fax": "202-228-6321",
        "contact_form": "http://www.brown.senate.gov/contact/",
        "office": "713 Hart Senate Office Building"
      },
      {
        "type": "sen",
        "start": "2013-01-03",
        "end": "2019-01-03",
        "state": "OH",
        "party": "Democrat",
        "class": 1,
        "url": "https://www.brown.senate.gov",
        "address": "713 Hart Senate Office Building Washington DC 20510",
        "phone": "202-224-2315",
        "fax": "202-228-6321",
        "contact_form": "http://www.brown.senate.gov/contact/",
        "office": "713 Hart Senate Office Building",
        "state_rank": "senior",
        "rss_url": "http://www.brown.senate.gov/rss/feeds/?type=all&amp;"
      },
      {
        "type": "sen",
        "start": "2019-01-03",
        "end": "2025-01-03",
        "state": "OH",
        "class": 1,
        "party": "Democrat",
        "state_rank": "senior",
        "url": "https://www.brown.senate.gov",
        "rss_url": "http://www.brown.senate.gov/rss/feeds/?type=all&amp;",
        "contact_form": "http://www.brown.senate.gov/contact/",
        "address": "503 Hart Senate Office Building Washington DC 20510",
        "office": "503 Hart Senate Office Building",
        "phone": "202-224-2315"
      }
    ]
  }, */

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
