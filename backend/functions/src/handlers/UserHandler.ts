import {
  LocationUpdateResponse,
  LocationLatLng,
  Location,
  TokenUpdate,
} from "../model/User";
import { FirebaseAdminService } from "../services/FirebaseAdminService";
import node_geocoder from "node-geocoder";
import * as functions from "firebase-functions";

const firebaseAdminService = new FirebaseAdminService();

const options = <node_geocoder.Options>{
  provider: "google",
  apiKey: functions.config().geocoding.key,
};

const geocoder = node_geocoder(options);

export class UserHandler {
  async updateToken(userId: string, tokenUpdate: TokenUpdate): Promise<undefined> {
    return firebaseAdminService
      .updateNotificationToken(userId, tokenUpdate.token)
      .then((value) => undefined);
  }

  async updateLocation(
    userId: string,
    latlng: LocationLatLng
  ): Promise<LocationUpdateResponse> {
    const res = await geocoder.reverse({ lat: latlng.lat, lon: latlng.lng });
    const locationResp = res[0];

    // TODO Parse user district
    const location: Location = {
      state: locationResp.administrativeLevels!.level1short!,
      latlng: {
        lat: locationResp!.latitude!,
        lng: locationResp!.longitude!,
      },
      zipcode: locationResp.zipcode!,
      legislativeDistrict: "",
      congressionalDistrict: "",
    };

    return {
      location: await firebaseAdminService.updateLocation(userId, location),
    };
  }

  async getLocation(userId: string): Promise<LocationUpdateResponse> {
    return {
      location: await firebaseAdminService.getLocation(userId),
    };
  }
}
