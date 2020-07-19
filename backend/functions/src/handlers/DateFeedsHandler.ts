import { KeyVoteService } from "../services/KeyVoteService";
import { StateFeedResponse } from "../model/Feed";
import { RepresentativeService } from "../services/RepresentativeService";

const keyVoteService = new KeyVoteService();
const representativeService = new RepresentativeService();

export class DataFeedsHandler {
  async getStateFeed(state: string): Promise<StateFeedResponse> {
    return {
      feed: await keyVoteService.getKeyVotes(state),
      representatives: await representativeService.getFeedSenatorsByState(state),
    };
  }
}
