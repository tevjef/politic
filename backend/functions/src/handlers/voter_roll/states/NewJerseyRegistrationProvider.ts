import { VoterInformation, CheckRegistrationResponse, StatusResultNotFoundValue, StatusResultNotEnrolledValue } from '../../../model/VoterRegistration';
import { StatusProvider, FieldsProvider, NotEnrolledProvider, StatusUnavailableProvider } from '../../VoterRollHandler';
import { NewJerseyRegistrationService } from '../../../services/NewJerseyRegistrationService';

const newJerseyRegistrationService = new NewJerseyRegistrationService()

export class NewJerseyRegistrationProvider implements StatusProvider, FieldsProvider, NotEnrolledProvider, StatusUnavailableProvider {

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
            label: "1-877-NJVOTER (1-877-658-6837)",
            uri: "tel:18776586837",
          },
          requirements: `
**To register in New Jersey, you must be:**


- A United States citizen
- At least 17 years old, though you may not vote until you have reached the age of 18
- A resident of the county for 30 days before the election
- A person not serving a sentence of incarceration as  the result of a conviction of any indictable offense under the laws of this or another state or of the United States
`,
          registrationUrl: { 
            label: "NJ Division of Elections",
            uri: "https://nj.gov/state/elections/voter-registration.shtml"
          }
        };
    }
    
    fields(): string[] {
        return [
            "firstName",
            "lastName",
            "dobMY"
        ]
    }
    
    async checkStatus(info: VoterInformation): Promise<CheckRegistrationResponse> {
        const response = await newJerseyRegistrationService.checkStatus(info);
        if (response.voterStatus.type === "notEnrolled") {
            return {
                voterStatus: {
                    type: "notEnrolled",
                    value: {
                        phone: this.enrollmentData().phone,
                        registrationUrl: this.enrollmentData().registrationUrl,
                        requirements: this.enrollmentData().requirements
                    }
                }
            }
        }

        return response
    }
}