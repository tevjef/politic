import { FeedRepresentative } from "../model/Feed";
import axios from "axios";
import { Legislator } from "../model/github_unitedstates/Legislators";
import { imageFromBioguide, ImageSize } from "./util/legislator_utils";

let legislators: Legislator[] = [];

export class RepresentativeService {
  async getCurrentLegislators(): Promise<Legislator[]> {
    if (legislators.length > 0) {
      return legislators;
    }
    const resp = await axios({
      url:
        "https://raw.githubusercontent.com/unitedstates/congress-legislators/gh-pages/legislators-current.json",
    });

    legislators = resp.data;
    return legislators;
  }

  async getLegislatorByName(name: string): Promise<Legislator | undefined> {
    return (await this.getCurrentLegislators()).find(byName(name));
  }

  async getFeedSenatorsByState(
    state: string,
    congressionalDistrict: string | undefined
  ): Promise<FeedRepresentative[]> {
    let cdRep: FeedRepresentative[] | undefined = undefined;
    if (congressionalDistrict !== undefined) {
      cdRep = (await this.getCurrentLegislators())
        .filter(byState(state))
        .filter(isHouseRepresentative)
        .filter(byCongressionalDistrict(congressionalDistrict))
        .map(
          (item) =>
            <FeedRepresentative>{
              displayName: `${item.name.first[0]}. ${item.name.last}`,
              image: imageFromBioguide(item.id.bioguide, ImageSize.small),
              party: item.terms[item.terms.length - 1].party,
              bioguide: item.id.bioguide,
            }
        );
    }

    const stateRep = (await this.getCurrentLegislators())
      .filter(byState(state))
      .filter(isSenator)
      .map(
        (item) =>
          <FeedRepresentative>{
            displayName: `${item.name.first[0]}. ${item.name.last}`,
            image: imageFromBioguide(item.id.bioguide, ImageSize.small),
            party: item.terms[item.terms.length - 1].party,
            bioguide: item.id.bioguide,
          }
      );

    return stateRep.concat(cdRep ?? []);
  }

  async getRssFeedSenatorsByState(
    state: string,
    congressionalDistrict: string | undefined
  ): Promise<string[]> {
    let cdRep: string[] | undefined = undefined;
    if (congressionalDistrict !== undefined) {
      cdRep = (await this.getCurrentLegislators())
        .filter(byState(state))
        .filter(isHouseRepresentative)
        .filter(byCongressionalDistrict(congressionalDistrict))
        .map((item) => item.terms[item.terms.length - 1].rss_url);
    }

    const stateRep = (await this.getCurrentLegislators())
      .filter(byState(state))
      .filter(isSenator)
      .map((item) => item.terms[item.terms.length - 1].rss_url);


    return stateRep.concat(cdRep ?? []);
  }
}

function byState(state: string) {
  return function (element: Legislator, index: any, array: Legislator[]) {
    const lastTerm = element.terms.length - 1;
    return element.terms[lastTerm].state === state;
  };
}

function byName(name: string) {
  return function (element: Legislator, index: any, array: Legislator[]) {
    return element.name.official_full === name || element.id.wikipedia === name;
  };
}

function isSenator(
  element: Legislator,
  index: any,
  array: Legislator[]
): boolean {
  const lastTerm = element.terms.length - 1;
  return element.terms[lastTerm].type === "sen";
}

function isHouseRepresentative(
  element: Legislator,
  index: any,
  array: Legislator[]
): boolean {
  const lastTerm = element.terms.length - 1;
  return element.terms[lastTerm].type === "rep";
}

function byCongressionalDistrict(district: string) {
  return function (element: Legislator, index: any, array: Legislator[]) {
    const lastTerm = element.terms.length - 1;
    return element.terms[lastTerm].district.toString() === district;
  };
}
