import {
  LegislatorsResponse,
  FeedRepresentative,
  LocalRepresentative,
  ElectionResponse,
  PollingLocation,
  ElectionsResponse,
  ElectionItem,
  Contest,
  Candidate,
} from "../model/Feed";
import axios from "axios";
import * as functions from "firebase-functions";
import { RepresentativeService } from "./RepresentativeService";
import { statesMap, titleCase } from "./util/state_utils";
import moment from "moment";
import {
  GoogleVoterInfoResponse,
  GoogleElectionsResponse,
  PollingLocation as GooglePollingLocation,
  Election,
} from "../model/google_civicapi/VoterInfo";
import { ImageSize, imageFromBioguide } from "./util/legislator_utils";
import { GeocodingService } from "./GeocodingService";
import { FirebaseAdminService } from "./FirebaseAdminService";
import { Deeplink } from "../model/VoterRegistration";

const GOOGLE_REPRESENTATIVES_API =
  "https://www.googleapis.com/civicinfo/v2/representatives?includeOffices=true";

const GOOGLE_ELECTIONS_API =
  "https://www.googleapis.com/civicinfo/v2/elections?";

const GOOGLE_VOTER_INFO_API =
  "https://www.googleapis.com/civicinfo/v2/voterinfo?";

const apiKey = functions.config().civicapi.key;

const federal_pattern: RegExp = RegExp("^ocd-division/country:us$");
const state_pattern = /ocd-division\/country:us\/state:(\D{2}$)/;
const cd_pattern = /ocd-division\/country:us\/state:(\D{2})\/cd:(\d*)/;
const ld_pattern = /ocd-division\/country:us\/state:(\D{2})\/sldu:(\d*)/;
// const sl_pattern = /ocd-division\/country:us\/state:(\D{2})\/(sldl:|sldu:)/;
// const county_pattern = /ocd-division\/country:us\/state:\D{2}\/county:\D+/;
// const local_pattern = /ocd-division\/country:us\/state:\D{2}\/place:\D+/;
// const district_pattern = /ocd-division\/country:us\/district:\D+/;

const representativeService = new RepresentativeService();
const geocodingService = new GeocodingService();
const firebaseAdminService = new FirebaseAdminService();

export class CivicInformationService {
  async getPollingLocations(pollingLocations: GooglePollingLocation[]) {
    return await Promise.all(
      pollingLocations.map(async (data) => {
        const formattedAddress = `${data.address.line1}, ${data.address.city}, ${data.address.state} ${data.address.zip}`;
        const key = await firebaseAdminService.getImageKey(formattedAddress);
        const imageUrl = await geocodingService.getOrCacheAddress(
          formattedAddress,
          key
        );
        return <PollingLocation>{
          locationName: titleCase(data.address.locationName ?? data.name),
          address: formattedAddress,
          imageUrl: imageUrl,
          pollingHours: data.pollingHours,
          startDate: data.startDate,
          endDate: data.endDate,
        };
      })
    );
  }

  async findAllElections(): Promise<ElectionsResponse> {
    const response = await this.getElectionsFromCivicApi();

    return {
      elections: response.elections
        .filter((value: Election, index: number, array: Election[]) => {
          return !value.name.toLowerCase().includes("test");
        })
        .sort((a: Election, b: Election) => {
          const aDay = moment(a.electionDay, "YYYY-MM-DD");
          const bDay = moment(b.electionDay, "YYYY-MM-DD");
          return aDay.unix() - bDay.unix();
        })
        .map((data) => {
          const day = moment(data.electionDay, "YYYY-MM-DD").format("LL");

          return <ElectionItem>{
            id: data.id,
            electionDay: day,
            electionName: data.name,
          };
        }),
    };
  }

  async findVoterInfo(
    address: string,
    electionId: string = "0"
  ): Promise<ElectionResponse> {
    const response:
      | GoogleVoterInfoResponse
      | number = await this.getVoterInfoFromCivicApi(address, electionId)
      .then((d) => d.data)
      .catch((err) => err);

    console.log(address);
    console.log(electionId);
    if (response instanceof Error) {
      return {};
    }

    const voterInfoResponse = response as GoogleVoterInfoResponse;

    let pollingLocations: PollingLocation[] | undefined = undefined;
    if (voterInfoResponse.pollingLocations !== undefined) {
      pollingLocations = await this.getPollingLocations(
        voterInfoResponse.pollingLocations
      );
    }

    let earlyVoteSites: PollingLocation[] | undefined = undefined;
    if (voterInfoResponse.earlyVoteSites !== undefined) {
      earlyVoteSites = await this.getPollingLocations(
        voterInfoResponse.earlyVoteSites
      );
    }

    let dropOffLocations: PollingLocation[] | undefined = undefined;
    if (voterInfoResponse.dropOffLocations !== undefined) {
      dropOffLocations = await this.getPollingLocations(
        voterInfoResponse.dropOffLocations
      );
    }

    const contests = voterInfoResponse.contests?.map((data) => {
      return <Contest>{
        title: titleCase(data.office),
        subtitle: `${titleCase(data.type)}`,
        candidates: data.candidates.map((candidate) => {
          return <Candidate>{
            name: titleCase(candidate.name),
            party: titleCase(candidate.party),
          };
        }),
      };
    });

    const stateElectionInfo =
      voterInfoResponse.state[0].electionAdministrationBody;
    const electionInfoDeeplink:
      | Deeplink
      | undefined = stateElectionInfo.electionInfoUrl
      ? {
          label: new URL(stateElectionInfo.electionInfoUrl).host,
          uri: stateElectionInfo.electionInfoUrl,
        }
      : undefined;

    const absenteeVotingInfoDeeplink:
      | Deeplink
      | undefined = stateElectionInfo.absenteeVotingInfoUrl
      ? {
          label: new URL(stateElectionInfo.absenteeVotingInfoUrl).host,
          uri: stateElectionInfo.absenteeVotingInfoUrl,
        }
      : undefined;

    const ballotInfoDeeplink:
      | Deeplink
      | undefined = stateElectionInfo.ballotInfoUrl
      ? {
          label: new URL(stateElectionInfo.ballotInfoUrl).host,
          uri: stateElectionInfo.ballotInfoUrl,
        }
      : undefined;

    const electionRegistrationDeeplink:
      | Deeplink
      | undefined = stateElectionInfo.electionRegistrationUrl
      ? {
          label: new URL(stateElectionInfo.electionRegistrationUrl).host,
          uri: stateElectionInfo.electionRegistrationUrl,
        }
      : undefined;

    return {
      election: {
        electionName: voterInfoResponse.election.name,
        electionDay: moment(
          voterInfoResponse.election.electionDay,
          "YYYY-MM-DD"
        ).format("LL"),
        contests: contests,
        pollingLocations: pollingLocations,
        earlyVoteSites: earlyVoteSites,
        dropOffLocations: dropOffLocations,
        electionAdministrationBody: {
          name: stateElectionInfo.name,
          electionInfoUrl: electionInfoDeeplink,
          electionRegistrationUrl: electionRegistrationDeeplink,
          absenteeVotingInfoUrl: absenteeVotingInfoDeeplink,
          ballotInfoUrl: ballotInfoDeeplink,
        },
      },
    };
  }

  async getDistrict(address: string): Promise<DistrictInfo> {
    const response: GoogleRepresentatives = (
      await this.getRepsFromCivicApi(address)
    ).data;

    let cd = "";
    let ld = "";

    const cdResult = await response.offices
      .find(byOfficeDivision(cd_pattern))
      ?.divisionId.match(cd_pattern);

    if (cdResult !== undefined && cdResult !== null) {
      cd = cdResult[2];
    }

    const ldResult = await response.offices
      .find(byOfficeDivision(ld_pattern))
      ?.divisionId.match(ld_pattern);

    if (ldResult !== undefined && ldResult !== null) {
      ld = ldResult[2];
    }

    return {
      cd: cd,
      ld: ld,
    };
  }

  async findRepresentatives(address: string): Promise<LegislatorsResponse> {
    const response: GoogleRepresentatives = (
      await this.getRepsFromCivicApi(address)
    ).data;

    const senateReps: FeedRepresentative[] = await Promise.all(
      response.offices
        .find(byOfficeDivision(state_pattern))
        ?.officialIndices.map(async (index) => {
          const official = response.officials[index];
          const legislator = await representativeService.getLegislatorByName(
            official.name
          );
          const photoUrl =
            official.photoUrl ?? legislator !== null
              ? imageFromBioguide(legislator!.id.bioguide, ImageSize.small)
              : null;
          const lastterm = legislator?.terms[legislator?.terms.length - 1];
          const rank = lastterm?.state_rank === "junior" ? "Junior" : "Senior";
          const stateName = statesMap[lastterm?.state ?? ""];
          const startDate = moment(lastterm!.start, "YYYY-MM-DD").format("LL");
          return <FeedRepresentative>{
            displayName: official.name,
            image: photoUrl,
            party: official.party,
            description: `${rank} Senator for ${stateName} since ${startDate}`,
          };
        })!
    );

    const cdRep: FeedRepresentative = await response.offices
      .find(byOfficeDivision(cd_pattern))
      ?.officialIndices.map(async (index) => {
        const official = response.officials[index];
        if (official.name === "VACANT") {
          return <FeedRepresentative>{
            displayName: official.name,
            party: official.party,
            description: `This seat is currently vacant.`,
          };
        }
        const legislator = await representativeService.getLegislatorByName(
          official.name
        );

        if (legislator === undefined) {
          return <FeedRepresentative>{
            displayName: official.name,
            image: official.photoUrl,
            party: official.party,
            description: ``,
          };
        }

        const lastterm = legislator?.terms[legislator?.terms.length - 1];
        const stateName = statesMap[lastterm!.state];
        const startDate = moment(lastterm!.start, "YYYY-MM-DD").format("LL");
        const district = `${lastterm!.district}${getOrdinal(
          lastterm!.district
        )}`;
        return <FeedRepresentative>{
          displayName: official.name,
          image: official.photoUrl,
          party: official.party,
          description: `Representative for ${stateName}'s ${district} congressional district since ${startDate}`,
        };
      })[0]!;

    const others: LocalRepresentative[] = response.offices
      .filter(notFederalRepresentative)
      .map((office) => {
        const officials = office.officialIndices.map((index) => {
          const official = response.officials[index];
          return <FeedRepresentative>{
            displayName: official.name,
            party: official.party,
          };
        });

        return <LocalRepresentative>{
          officeTitle: office.name,
          officials: officials,
        };
      });

    return {
      senators: senateReps ?? [],
      representative: {
        localRepresentative: cdRep,
      },
      local: others,
    };
  }

  private async getRepsFromCivicApi(address: string) {
    const url = encodeURI(
      GOOGLE_REPRESENTATIVES_API.concat("&address=")
        .concat(address)
        .concat("&key=")
        .concat(apiKey)
    );

    return await axios({
      url: url,
      method: "get",
      headers: {
        "content-type": "application/json",
        accept: "application/json, text/plain, */*",
      },
    });
  }

  private async getVoterInfoFromCivicApi(
    address: string,
    electionId: string = "0"
  ) {
    const url = encodeURI(
      GOOGLE_VOTER_INFO_API.concat("address=")
        .concat(address)
        .concat("&electionId=")
        .concat(electionId)
        .concat("&key=")
        .concat(apiKey)
    );

    return await axios({
      url: url,
      method: "get",
      headers: {
        "content-type": "application/json",
        accept: "application/json, text/plain, */*",
      },
    });
  }

  private async getElectionsFromCivicApi(): Promise<GoogleElectionsResponse> {
    const url = encodeURI(GOOGLE_ELECTIONS_API.concat("key=").concat(apiKey));

    const resp = await axios({
      url: url,
      method: "get",
      headers: {
        "content-type": "application/json",
        accept: "application/json, text/plain, */*",
      },
    });

    return resp.data;
  }
}

function byOfficeDivision(divisionId: RegExp) {
  return function (element: Office, index: any, array: Office[]) {
    return divisionId.test(element.divisionId);
  };
}
function notFederalRepresentative(
  element: Office,
  index: any,
  array: Office[]
) {
  const isNotFederal =
    !federal_pattern.test(element.divisionId) &&
    !element.levels.includes("country");

  return isNotFederal;
}

function getOrdinal(d: number) {
  if (d > 3 && d < 21) return "th";
  switch (d % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

export interface DistrictInfo {
  cd: string;
  ld: string;
}

export interface NormalizedInput {
  line1: string;
  city: string;
  state: string;
  zip: string;
}

export interface OcdDivision {
  name: string;
  officeIndices: number[];
}

export interface Office {
  name: string;
  divisionId: string;
  levels: string[];
  officialIndices: number[];
}

export interface Address {
  line1: string;
  city: string;
  state: string;
  zip: string;
  line2: string;
}

export interface Channel {
  type: string;
  id: string;
}

export interface Official {
  name: string;
  address: Address[];
  party: string;
  phones: string[];
  urls: string[];
  photoUrl: string;
  channels: Channel[];
  emails: string[];
}

export interface GoogleRepresentatives {
  normalizedInput: NormalizedInput;
  kind: string;
  divisions: { [key: string]: OcdDivision };
  offices: Office[];
  officials: Official[];
}
