import {
  VoterInformation,
  CheckRegistrationResponse,
  StatusResultNotFoundValue,
  StatusResultNotEnrolledValue,
  FieldInputDescriptor,
} from "../../../model/VoterRegistration";
import {
  StatusProvider,
  FieldsProvider,
  NotEnrolledProvider,
  StatusUnavailableProvider,
} from "../../VoterRollHandler";

export class DefaultRegistrationProvider
  implements
    StatusProvider,
    FieldsProvider,
    StatusUnavailableProvider,
    NotEnrolledProvider {
  enrollmentData(): StatusResultNotEnrolledValue {
    return {
      phone: { label: "1-800-FOR-VOTE", uri: "tel:555-555-5555" },
      requirements: "",
      registrationUrl: {
        label: "https://vote.org",
        uri: "https://vote.org",
      },
    };
  }

  statusUnavailableData(): StatusResultNotFoundValue {
    return {
      phone: this.enrollmentData().phone,
      requirements: this.enrollmentData().requirements,
      registrationUrl: this.enrollmentData().registrationUrl,
    };
  }

  fields(): FieldInputDescriptor[] {
    return [];
  }

  async checkStatus(
    info: VoterInformation
  ): Promise<CheckRegistrationResponse> {
    return {
      voterStatus: {
        type: "notFound",
        value: this.statusUnavailableData(),
      },
    };
  }
}
