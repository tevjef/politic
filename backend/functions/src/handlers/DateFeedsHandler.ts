import { KeyVoteService } from "../services/KeyVoteService";
import {
  StateFeedResponse,
  LegislatorsResponse,
  ElectionResponse,
  ElectionsResponse,
} from "../model/Feed";
import { RepresentativeService } from "../services/RepresentativeService";
import { CivicInformationService } from "../services/CivicInformationService";
import { FirebaseAdminService } from "../services/FirebaseAdminService";
import { GeocodingService } from "../services/GeocodingService";

const keyVoteService = new KeyVoteService();
const representativeService = new RepresentativeService();
const civicInformationService = new CivicInformationService();
const firebaseAdminService = new FirebaseAdminService();
const geocodingService = new GeocodingService();

export class DataFeedsHandler {
  async getElection(
    userId: string,
    electionId: string
  ): Promise<ElectionResponse> {
    const location = await firebaseAdminService.getLocation(userId);
    const address = await geocodingService.getFormattedAddress(
      location.latlng!.lat,
      location.latlng!.lng
    );
    return civicInformationService.findVoterInfo(address, electionId);
  }

  async getStateFeed(
    state: string,
    congressionalDistrict: string | undefined
  ): Promise<StateFeedResponse> {
    const repRss = await representativeService.getRssFeedSenatorsByState(
      state,
      congressionalDistrict
    );

    return {
      feed: await keyVoteService.getKeyVotes(state, repRss),
      representatives: await representativeService.getFeedSenatorsByState(
        state,
        congressionalDistrict
      ),
    };
  }

  async getRepresentatives(userId: string): Promise<LegislatorsResponse> {
    const location = await firebaseAdminService.getLocation(userId);
    const address = await geocodingService.getFormattedAddress(
      location.latlng!.lat,
      location.latlng!.lng
    );

    return civicInformationService.findRepresentatives(address);
  }

  async getUserVoterInfo(userId: string): Promise<ElectionResponse> {
    const location = await firebaseAdminService.getLocation(userId);
    const address = await geocodingService.getFormattedAddress(
      location.latlng!.lat,
      location.latlng!.lng
    );

    return civicInformationService.findVoterInfo(address);
  }

  async getAllElections(): Promise<ElectionsResponse> {
    return civicInformationService.findAllElections();
  }
}
