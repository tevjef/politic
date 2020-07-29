import * as validator from "class-validator";
// tslint:disable-next-line:no-import-side-effect
import "reflect-metadata";
import { Type } from "class-transformer";

export class CheckRegistrationRequest {
  @validator.IsNotEmptyObject()
  @Type(() => VoterInformation)
  public voterInformation!: VoterInformation;
}

export class EnrollmentRequest {
  @validator.ValidateNested({ always: true })
  @validator.IsNotEmptyObject()
  @Type(() => Enrollment)
  public enrollment!: Enrollment;
}

export class Enrollment {
  @validator.IsNotEmptyObject()
  @Type(() => VoterInformation)
  public voterInformation!: VoterInformation;

  @validator.IsString()
  public notificationToken!: string;
}

export class ManualEnrollmentRequest {
  @validator.ValidateNested({ always: true })
  @validator.IsNotEmptyObject()
  @Type(() => ManualEnrollment)
  public enrollment!: ManualEnrollment;
}

export class ManualEnrollment {
  @validator.IsString()
  public notificationToken!: string;
}

export class VoterInformation {
  state!: string;

  county!: string;

  zipcode!: string;

  firstName!: string;

  lastName!: string;

  middleInitial!: string;

  day!: string;

  month!: string;

  year!: number;
}

export interface CheckRegistrationResponse {
  voterStatus: VoterStatus;
}

export type StatusResultType =
  | "multipleEnrolled"
  | "singleEnrolled"
  | "notEnrolled"
  | "notFound";

export interface StatusResultSingleValue {
  title: string;
  message: string;
}

export interface StatusResultNotEnrolledValue {
  phone: Deeplink;
  requirements: string;
  registrationUrl: Deeplink;
}

export interface Deeplink {
  label: String;
  uri: String;
}

export interface StatusResultNotFoundValue {
  phone: Deeplink;
  requirements: string;
  registrationUrl: Deeplink;
}

export type StatusResultValue =
  | StatusResultSingleValue
  | StatusResultSingleValue[]
  | StatusResultNotEnrolledValue
  | StatusResultNotFoundValue;

export interface VoterStatus {
  type: StatusResultType;
  value: StatusResultValue;
}

export interface StatesResponse {
  states: VoterState[];
}

export interface VoterState {
  name: string;
  abbreviation: string;
  fields: FieldInputDescriptor[];
}

export type FieldType = "text" | "number" | "dobMY" | "dobDMY" | "selection";

export type FieldKey =
  | "firstName"
  | "lastName"
  | "middleInitial"
  | "zipcode"
  | "composite"
  | "county";

export interface FieldInputDescriptor {
  inputType: FieldType;
  key: FieldKey;
  options?: string[];
}
