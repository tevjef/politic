import { VoterInformation, CheckRegistrationResponse, StatusResultNotFoundValue, StatusResultNotEnrolledValue } from '../../../model/VoterRegistration';
import { StatusProvider, FieldsProvider, NotEnrolledProvider, StatusUnavailableProvider } from '../StatusProvider';

export class DefaultRegistrationProvider implements 
    StatusProvider, 
    FieldsProvider, 
    StatusUnavailableProvider,
    NotEnrolledProvider {
    
    enrollmentData(): StatusResultNotEnrolledValue {
        return {
            requirements: "Not yet implemented",
            registrationUrl: "https://vote.org"
        }
    }

    statusUnavailableData(): StatusResultNotFoundValue {
        return {
            phone: "212-555-5555",
            website: "https://vote.org"
        }
    }
    
    fields(): string[] {
        return []
    }
    
    async checkStatus(info: VoterInformation): Promise<CheckRegistrationResponse> {
        return { 
            voterStatus: {
                type: 'notFound',
                value: this.statusUnavailableData()
        }}
    }
}