export interface CheckRegistrationRequest {
    voterInformation: VoterInformation
}

export interface VoterInformation {
    state: string;
    firstName: string;
    lastName: string;
    middleInitial: string;
    month: string;
    year: number
}

export interface CheckRegistrationResponse {
    voterStatus: VoterStatus
}

export type StatusResultType = 'multipleEnrolled' | 'singleEnrolled' | 'notEnrolled' | 'none'

export interface StatusResultSingleValue {
    title: string;
    message: string;
}

export type StatusResultValue = StatusResultSingleValue | StatusResultSingleValue[]

export interface VoterStatus {
    type: StatusResultType;
    value: StatusResultValue;
}