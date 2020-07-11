import * as validator from 'class-validator';
// tslint:disable-next-line:no-import-side-effect
import 'reflect-metadata';
import { Type } from 'class-transformer';

export class CheckRegistrationRequest {

    @validator.ValidateNested({ always: true})
    @validator.IsNotEmptyObject()
    @Type(() => VoterInformation)
    public voterInformation!: VoterInformation;
}

export class VoterInformation {
    @validator.IsString()
    state!: string;

    @validator.IsString()
    firstName!: string;

    @validator.IsString()
    lastName!: string;

    middleInitial!: string;

    @validator.IsString()
    month!: string;

    @validator.IsNumber()
    year!: number;
}

export interface CheckRegistrationResponse {
    voterStatus: VoterStatus
}

export type StatusResultType = 'multipleEnrolled' | 'singleEnrolled' | 'notEnrolled' | 'notFound'

export interface StatusResultSingleValue {
    title: string;
    message: string;
}

export interface StatusResultNotEnrolledValue {
    requirements: string;
    registrationUrl: string;
}

export interface StatusResultNotFoundValue {
    phone: string;
    website: string;
}

export type StatusResultValue = StatusResultSingleValue | 
StatusResultSingleValue[] | 
StatusResultNotEnrolledValue |
StatusResultNotFoundValue

export interface VoterStatus {
    type: StatusResultType;
    value: StatusResultValue;
}

export interface StatesResponse {
    states: VoterState[];
}

export interface VoterState {
    name: string;
    abbreviation: string;
    fields: string[];
}