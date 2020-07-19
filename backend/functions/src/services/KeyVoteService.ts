import Parser from "rss-parser";
import { FeedItem } from "../model/Feed";

const parser = new Parser();

export class KeyVoteService {
  async getKeyVotes(state: String): Promise<FeedItem[]> {
    const feed = await parser.parseURL(
      `http://votesmart.org/rss/key-votes/${state}`
    );

    return feed.items!.map(
      (item) =>
        <FeedItem>{
          itemType: "keyVote",
          title: item.title,
          link: item.link,
        }
    );
  }
}
