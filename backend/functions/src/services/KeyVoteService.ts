import Parser from "rss-parser";
import { FeedItem } from "../model/Feed";

const parser = new Parser();

export class KeyVoteService {
  async getKeyVotes(state: string, repRss: string[]): Promise<FeedItem[]> {
    const repFeeds: (FeedItem[] | undefined)[] = await Promise.all(
      repRss.map(async (value) => {
        if (value === undefined) return;

        const result = await parser.parseURL(value).catch((err) => undefined);
        if (result === undefined) return;

        return result.items!.map((item) => {
          return <FeedItem>{
            itemType: "pressRelease",
            title: item.title?.trim(),
            link: item.link,
          };
        });
      })
    );

    const repFeed: FeedItem[] = [];
    repFeeds?.forEach((value) => {
      value?.forEach((value1) => {
        repFeed.push(value1);
      });
    });

    const feed = await parser.parseURL(
      `http://votesmart.org/rss/key-votes/${state}`
    );

    const keyVoteFeed = feed.items!.map(
      (item) =>
        <FeedItem>{
          itemType: "keyVote",
          title: item.title?.trim(),
          link: item.link,
        }
    );

    const mainList =
      keyVoteFeed.length > repFeed.length ? keyVoteFeed : repFeed;
    const finalFeed: FeedItem[] = [];
    for (let i = 0; i < mainList.length; i++) {
      if (i < keyVoteFeed.length) {
        finalFeed.push(keyVoteFeed[i]);
      }
      if (i < repFeed.length) {
        finalFeed.push(repFeed[i]);
      }
    }

    return finalFeed;
  }
}
