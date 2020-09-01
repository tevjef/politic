import * as functions from "firebase-functions";
import {
  Client,
  AddressType,
  GeocodeResult,
  PlaceAutocompleteType,
} from "@googlemaps/google-maps-services-js";
import axios from "axios";
import tmp from "tmp";
import fs from "fs";
import { FirebaseAdminService } from "./FirebaseAdminService";

const client = new Client({});

const apiKey = functions.config().geocoding.key;

const firebaseAdminService = new FirebaseAdminService();

export class GeocodingService {
  async autocomplete(input: string): Promise<string[]> {
    const response = await client.placeAutocomplete({
      params: {
        input: input,
        key: apiKey,
        components: ["country:us"],
        types: PlaceAutocompleteType.address
      },
    });


    return response.data.predictions.map((value) => {
      return value.description
    })
  }

  async getFormattedAddress(lat: number, lng: number): Promise<string> {
    const response = await client.reverseGeocode({
      params: {
        latlng: {
          latitude: lat,
          longitude: lng,
        },
        result_type: [AddressType.street_address],
        key: apiKey,
      },
    });

    const results: GeocodeResult[] = response.data.results;

    const location = results.find(
      (value: GeocodeResult, index: number, array: GeocodeResult[]) => {
        return !value.partial_match;
      }
    );
    return location?.formatted_address ?? "";
  }

  async getOrCacheAddress(address: string, key: string): Promise<string> {
    const existing = await firebaseAdminService.getLocationPhoto(key);
    if (existing !== undefined) {
      return existing;
    }

    const mapUrl = new URL("https://maps.googleapis.com/maps/api/staticmap");
    mapUrl.searchParams.append("center", address);
    mapUrl.searchParams.append("size", "400x130");
    mapUrl.searchParams.append("markers", address);
    mapUrl.searchParams.append("key", apiKey);

    const path = await axios({
      method: "get",
      url: mapUrl.toString(),
      responseType: "stream",
    }).then((response) => {
      const fileDescriptor = tmp.fileSync();
      response.data.pipe(fs.createWriteStream(fileDescriptor.name));
      return fileDescriptor.name
    });

    return firebaseAdminService.uploadLocationPhoto(path, key);
  }
}
