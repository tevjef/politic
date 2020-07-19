export interface StateFeedResponse {
  feed: FeedItem[];
  representatives: FeedRepresentative[];
}

export interface FeedItem {
  itemType: FeedItemType;
  title: String;
  link: String;
}

export type FeedItemType = "keyVote" | "pressRelease";


export interface FeedRepresentative {
    displayName: string;
    image: string;
    bioguide: string
}