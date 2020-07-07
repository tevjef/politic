import { 
    VoterInformation, 
    CheckRegistrationResponse 
} from '../../model/VoterRegistration'

export type StatusProviderMap = Record<string, StatusProvider>

export interface StatusProvider {
    checkStatus(info: VoterInformation): Promise<CheckRegistrationResponse>
}