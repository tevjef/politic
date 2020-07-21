import * as validator from "class-validator";
// tslint:disable-next-line:no-import-side-effect
import "reflect-metadata";
import { Type } from "class-transformer";

export class LocationUpdateRequest {
  @validator.IsNotEmptyObject()
  @Type(() => LocationLatLng)
  locationUpdate!: LocationLatLng;
}

export class LocationLatLng {
  @validator.IsNumber()
  lat!: number;
  @validator.IsNumber()
  lng!: number;
}

export class NotificationTokenUpdateRequest {
  @validator.IsNotEmptyObject()
  @Type(() => TokenUpdate)
  tokenUpdate!: TokenUpdate;
}

export class TokenUpdate {
  @validator.IsString()
  token!: string;
}

export interface LocationUpdateResponse {
  location: Location;
}

export interface Location {
  state: string;
  zipcode: string;
  latlng: LocationLatLng;
  legislativeDistrict: string;
  congressionalDistrict: string;
}
