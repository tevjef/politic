export enum ImageSize {
  large = "original",
  small = "225x275",
}

export function imageFromBioguide(bioguide: string, imageSize: ImageSize): string {
  return `https://theunitedstates.io/images/congress/${imageSize}/${bioguide}.jpg`;
}
