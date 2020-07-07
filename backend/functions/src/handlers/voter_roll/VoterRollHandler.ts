import { 
    CheckRegistrationRequest, 
    CheckRegistrationResponse 
} from '../../model/VoterRegistration'

import { NewJerseyRegistrationStatusProvider } from './states/NewJerseyRegistrationStatusProvider'
import { StatusProviderMap } from './StatusProvider';

const statusProviders: StatusProviderMap = {
    "NJ" : new NewJerseyRegistrationStatusProvider()
}

export class VoterRollHandler {
    async checkRegistration(request: CheckRegistrationRequest): Promise<CheckRegistrationResponse> {
        const provider = statusProviders[request.voterInformation.state]
        return provider.checkStatus(request.voterInformation)
    }
}