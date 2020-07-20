import {
  CheckRegistrationRequest,
  CheckRegistrationResponse,
  StatesResponse,
  VoterInformation,
  StatusResultNotFoundValue,
  StatusResultNotEnrolledValue,
  EnrollmentRequest,
  FieldInputDescriptor,
} from "../model/VoterRegistration";
import { DefaultRegistrationProvider } from "./voter_roll/states/DefaultRegistrationProvider";
import { NewJerseyRegistrationProvider } from "./voter_roll/states/NewJerseyRegistrationProvider";
import { FirebaseAdminService } from "../services/FirebaseAdminService";

const defaultProvider = new DefaultRegistrationProvider();
const firebaseAdminService = new FirebaseAdminService();

const statusProviders: ProviderMap = {
  NJ: new NewJerseyRegistrationProvider(),
};

export class VoterRollHandler {
  async saveVoterInformation(userUUID: string, request: EnrollmentRequest): Promise<null> {
    await firebaseAdminService.addVoterInformation(userUUID, request.enrollment.voterInformation)
    return firebaseAdminService.addNotificationToken(
      userUUID,
      request.enrollment.notificationToken
    ).then(value => null);
  }

  async checkRegistration(
    request: CheckRegistrationRequest
  ): Promise<CheckRegistrationResponse> {
    if (request.voterInformation.firstName?.toLowerCase() === "apptester") {
      const result = await this.handleTestUser(request);
      if (result !== null) {
        return result;
      }
    }

    const provider =
      statusProviders[request.voterInformation.state] ?? defaultProvider;
      console.log((await provider.checkStatus(request.voterInformation)).voterStatus);
      return provider.checkStatus(request.voterInformation);
  }

  async getStates(): Promise<StatesResponse> {
    return {
      states: Object.entries(states).map(([key, value]) => {
        const provider = statusProviders[key] ?? defaultProvider;
        return {
          name: value,
          abbreviation: key,
          fields: provider.fields(),
        };
      }),
    };
  }

  async handleTestUser(
    request: CheckRegistrationRequest
  ): Promise<CheckRegistrationResponse | null> {
    if (request.voterInformation.lastName.toLowerCase() === "fail") {
      const enrollmentData = statusProviders["NJ"].enrollmentData();
      return {
        voterStatus: {
          type: "notEnrolled",
          value: {
            phone: enrollmentData.phone,
            registrationUrl: enrollmentData.registrationUrl,
            requirements: enrollmentData.requirements,
          },
        },
      };
    }
    if (request.voterInformation.lastName.toLowerCase() === "pass") {
      return {
        voterStatus: {
          type: "singleEnrolled",
          value: [
            {
              title: "Full Name",
              message: "App Store Tester",
            },
            {
              title: "Testing Date",
              message: new Date().toISOString(),
            },
          ],
        },
      };
    }
    return null;
  }
}

const states = {
  AL: "Alabama",
  AK: "Alaska",
  AZ: "Arizona",
  AR: "Arkansas",
  CA: "California",
  CO: "Colorado",
  CT: "Connecticut",
  DE: "Delaware",
  DC: "District of Columbia",
  FL: "Florida",
  GA: "Georgia",
  HI: "Hawaii",
  ID: "Idaho",
  IL: "Illinois",
  IN: "Indiana",
  IA: "Iowa",
  KS: "Kansas",
  KY: "Kentucky",
  LA: "Louisiana",
  ME: "Maine",
  MD: "Maryland",
  MA: "Massachusetts",
  MI: "Michigan",
  MN: "Minnesota",
  MS: "Mississippi",
  MO: "Missouri",
  MT: "Montana",
  NE: "Nebraska",
  NV: "Nevada",
  NH: "New Hampshire",
  NJ: "New Jersey",
  NM: "New Mexico",
  NY: "New York",
  NC: "North Carolina",
  ND: "North Dakota",
  OH: "Ohio",
  OK: "Oklahoma",
  OR: "Oregon",
  PA: "Pennsylvania",
  RI: "Rhode Island",
  SC: "South Carolina",
  SD: "South Dakota",
  TN: "Tennessee",
  TX: "Texas",
  UT: "Utah",
  VT: "Vermont",
  VA: "Virginia",
  WA: "Washington",
  WV: "West Virginia",
  WI: "Wisconsin",
  WY: "Wyoming",
  GU: "Guam",
  PR: "Puerto Rico",
  AA: "U.S. Armed Forces – Americas",
  AE: "U.S. Armed Forces – Europe",
  AP: "U.S. Armed Forces – Pacific",
  VI: "U.S. Virgin Islands",
};

export type ProviderMap = Record<
  string,
  StatusProvider &
    FieldsProvider &
    NotEnrolledProvider &
    StatusUnavailableProvider
>;

export interface StatusProvider {
  checkStatus(info: VoterInformation): Promise<CheckRegistrationResponse>;
}

export interface StatusUnavailableProvider {
  statusUnavailableData(): StatusResultNotFoundValue;
}

export interface NotEnrolledProvider {
  enrollmentData(): StatusResultNotEnrolledValue;
}

export interface FieldsProvider {
  fields(): FieldInputDescriptor[];
}