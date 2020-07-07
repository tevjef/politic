import { VoterInformation, CheckRegistrationResponse } from '../../../model/VoterRegistration';
import { StatusProvider } from '../StatusProvider';
import { NewJerseyRegistrationService } from '../../../services/NewJerseyRegistrationService';

const newJerseyRegistrationService = new NewJerseyRegistrationService()

export class NewJerseyRegistrationStatusProvider implements StatusProvider {
    async checkStatus(info: VoterInformation): Promise<CheckRegistrationResponse> {
        return newJerseyRegistrationService.checkStatus(info)
    }
}