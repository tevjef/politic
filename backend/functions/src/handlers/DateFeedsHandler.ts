import { KeyVoteService } from "../services/KeyVoteService";
import {
  StateFeedResponse,
  LegislatorsResponse,
  ElectionResponse,
  ElectionsResponse,
} from "../model/Feed";
import { RepresentativeService } from "../services/RepresentativeService";
import { CivicInformationService } from "../services/CivicInformationService";
import node_geocoder from "node-geocoder";
import * as functions from "firebase-functions";
import { FirebaseAdminService } from "../services/FirebaseAdminService";

const keyVoteService = new KeyVoteService();
const representativeService = new RepresentativeService();
const civicInformationService = new CivicInformationService();
const firebaseAdminService = new FirebaseAdminService();

const options = <node_geocoder.Options>{
  provider: "google",
  apiKey: functions.config().geocoding.key,
};

const geocoder = node_geocoder(options);

export class DataFeedsHandler {
  async getElection(
    userId: string,
    electionId: string
  ): Promise<ElectionResponse> {
    const location = await firebaseAdminService.getLocation(userId);
    const res = await geocoder.reverse({
      lat: location.latlng.lat,
      lon: location.latlng.lng,
    });

    console.log("###################");
    console.log(electionId);

    return civicInformationService.findVoterInfo(
      res[0].formattedAddress ?? "",
      electionId
    );
  }

  async getStateFeed(state: string): Promise<StateFeedResponse> {
    return {
      feed: await keyVoteService.getKeyVotes(state),
      representatives: await representativeService.getFeedSenatorsByState(
        state
      ),
    };
  }

  async getRepresentatives(userId: string): Promise<LegislatorsResponse> {
    const location = await firebaseAdminService.getLocation(userId);
    const res = await geocoder.reverse({
      lat: location.latlng.lat,
      lon: location.latlng.lng,
    });

    return civicInformationService.findRepresentatives(
      res[0].formattedAddress ?? ""
    );
  }

  async getUserVoterInfo(userId: string): Promise<ElectionResponse> {
    const location = await firebaseAdminService.getLocation(userId);
    const res = await geocoder.reverse({
      lat: location.latlng.lat,
      lon: location.latlng.lng,
    });

    return civicInformationService.findVoterInfo(res[0].formattedAddress ?? "");
  }

  async getAllElections(): Promise<ElectionsResponse> {
    return civicInformationService.findAllElections();
  }
}
