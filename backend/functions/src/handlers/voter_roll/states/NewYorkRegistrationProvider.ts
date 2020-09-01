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
import { NewYorkRegistrationService } from "../../../services/NewYorkRegistrationService";

const newYorkRegistrationService = new NewYorkRegistrationService();

export class NewYorkRegistrationProvider
  implements
    StatusProvider,
    FieldsProvider,
    NotEnrolledProvider,
    StatusUnavailableProvider {
  statusUnavailableData(): StatusResultNotFoundValue {
    return {
      phone: this.enrollmentData().phone,
      requirements: this.enrollmentData().requirements,
      registrationUrl: this.enrollmentData().registrationUrl,
    };
  }

  enrollmentData(): StatusResultNotEnrolledValue {
    return {
      phone: {
        label: "1-800-FOR-VOTE",
        uri: "tel:18003678683",
      },
      requirements: `
**Qualifications to Register to Vote**


- be a United States citizen;
- be 18 years old (you may pre-register at 16 or 17 but cannot vote until you are 18);
- resident of this state and the county, city or village for at least 30 days before the election;
- not be in prison or on parole for a felony conviction (unless parolee pardoned or restored rights of citizenship);
- not be adjudged mentally incompetent by a court;
- not claim the right to vote elsewhere.
`,
      registrationUrl: {
        label: "New York State Board of Elections",
        uri: "https://voterreg.dmv.ny.gov/MotorVoter/",
      },
    };
  }

  fields(): FieldInputDescriptor[] {
    return [
      {
        inputType: "text",
        key: "firstName",
      },
      {
        inputType: "text",
        key: "lastName",
      },
/*       {
        inputType: "selection",
        key: "zipcode",
        options: [
          "Albany",
          "Allegany",
          "Bronx",
          "Broome",
          "Cattaraugus",
          "Cayuga",
          "Chautauqua",
          "Chemung",
          "Chenango",
          "Clinton",
          "Columbia",
          "Cortland",
          "Delaware",
          "Dutchess",
          "Erie",
          "Essex",
          "Franklin",
          "Fulton",
          "Genesee",
          "Greene",
          "Hamilton",
          "Herkimer",
          "Jefferson",
          "Kings (Brooklyn)",
          "Lewis",
          "Livingston",
          "Madison",
          "Monroe",
          "Montgomery",
          "Nassau",
          "New York (Manhattan)",
          "Niagara",
          "Oneida",
          "Onondaga",
          "Ontario",
          "Orange",
          "Orleans",
          "Oswego",
          "Otsego",
          "Putnam",
          "Queens",
          "Rensselaer",
          "Richmond (Staten Island)",
          "Rockland",
          "Saratoga",
          "Schenectady",
          "Schoharie",
          "Schuyler",
          "Seneca",
          "St.Lawrence",
          "Steuben",
          "Suffolk",
          "Sullivan",
          "Tioga",
          "Tompkins",
          "Ulster",
          "Warren",
          "Washington",
          "Wayne",
          "Westchester",
          "Wyoming",
          "Yates",
        ],
      }, */
      {
        inputType: "dobMY",
        key: "composite",
      },
    ];
  }

  async checkStatus(
    info: VoterInformation
  ): Promise<CheckRegistrationResponse> {
    console.log(info)
    if (
      info.firstName &&
      info.lastName &&
      info.month &&
      info.county &&
      info.day &&
      info.zipcode &&
      info.year
    ) {
      const response = await newYorkRegistrationService.checkStatus(info);

      if (response.voterStatus.type === "notEnrolled") {
        return {
          voterStatus: {
            type: "notEnrolled",
            value: {
              phone: this.enrollmentData().phone,
              registrationUrl: this.enrollmentData().registrationUrl,
              requirements: this.enrollmentData().requirements,
            },
          },
        };
      }

      return response;
    }

    return {
      voterStatus: {
        type: "notFound",
        value: this.statusUnavailableData(),
      },
    };
  }
}
