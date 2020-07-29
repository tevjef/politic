import { FeedRepresentative } from "../model/Feed";
import axios from "axios";
import { Legislator } from "../model/github_unitedstates/Legislators";

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
    return (await this.getCurrentLegislators())
      .find(byName(name));
  }

  async getFeedSenatorsByState(state: string): Promise<FeedRepresentative[]> {
    return (await this.getCurrentLegislators())
      .filter(byState(state))
      .filter(isSenator)
      .map(
        (item) =>
          <FeedRepresentative>{
            displayName: `${item.name.first[0]}. ${item.name.last}`,
            image: imageFromBioguide(item.id.bioguide, ImageSize.small),
            bioguide: item.id.bioguide,
          }
      );
  }
}

enum ImageSize {
  large = "original",
  small = "225x275",
}

function imageFromBioguide(bioguide: string, imageSize: ImageSize): string {
  return `https://theunitedstates.io/images/congress/${imageSize}/${bioguide}.jpg`;
}

function byState(state: string) {
  return function (element: Legislator, index: any, array: Legislator[]) {
    const lastTerm = element.terms.length - 1;
    return element.terms[lastTerm].state === state;
  };
}

function byName(name: string) {
  return function (element: Legislator, index: any, array: Legislator[]) {
    return element.name.official_full === name;
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
