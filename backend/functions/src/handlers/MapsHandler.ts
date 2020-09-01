import { GeocodingService } from "../services/GeocodingService";
import { AutocompleteResponse } from "../model/Maps";

const geocodingService = new GeocodingService();

export class MapsHandler {
  async autocomplete(input: string): Promise<AutocompleteResponse> {
    return {
      result: await geocodingService.autocomplete(input),
    };
  }
}
