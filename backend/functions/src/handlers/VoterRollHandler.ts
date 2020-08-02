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
import { NewYorkRegistrationProvider } from "./voter_roll/states/NewYorkRegistrationProvider";
import { statesMap } from "../services/util/state_utils";

const defaultProvider = new DefaultRegistrationProvider();
const firebaseAdminService = new FirebaseAdminService();

const statusProviders: ProviderMap = {
  NJ: new NewJerseyRegistrationProvider(),
  NY: new NewYorkRegistrationProvider(),
};

export class VoterRollHandler {
  async saveVoterInformation(
    userId: string,
    request: EnrollmentRequest
  ): Promise<undefined> {
    await firebaseAdminService.updateVoterInformation(
      userId,
      request.enrollment.voterInformation
    );
    return firebaseAdminService
      .updateNotificationToken(userId, request.enrollment.notificationToken)
      .then((value) => undefined);
  }

  async saveManualUser(
    userId: string,
    notificationToken: string
  ): Promise<undefined> {
    await firebaseAdminService.manualEnrollment(
      userId,
      new Date()
    );
    return firebaseAdminService
      .updateNotificationToken(userId, notificationToken)
      .then((value) => undefined);
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
    console.log(
      (await provider.checkStatus(request.voterInformation)).voterStatus
    );
    return provider.checkStatus(request.voterInformation);
  }

  async getStates(): Promise<StatesResponse> {
    return {
      states: Object.entries(statesMap).map(([key, value]) => {
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
