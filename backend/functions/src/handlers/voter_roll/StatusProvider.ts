import { 
    VoterInformation, 
    CheckRegistrationResponse,
    StatusResultNotFoundValue,
    StatusResultNotEnrolledValue
} from '../../model/VoterRegistration'

export type ProviderMap = Record<string, StatusProvider & FieldsProvider>

export interface StatusProvider {
    checkStatus(info: VoterInformation): Promise<CheckRegistrationResponse>
}

export interface StatusUnavailableProvider {
    statusUnavailableData(): StatusResultNotFoundValue
}

export interface NotEnrolledProvider {
    enrollmentData(): StatusResultNotEnrolledValue
}

export interface FieldsProvider {
    fields(): string[]
}