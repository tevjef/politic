import { VoterInformation, CheckRegistrationResponse } from '../model/VoterRegistration';
import axios from 'axios';
import moment from 'moment';

// Response format from  https://voter.svrs.nj.gov/api/voters
interface NJVotersApiResponse {
    firstName: string;
    lastName: string;
    middleInitial: string;
    county: string;
    city: string;
    dob: string;
    votingPrivilegeDate: string;
 }
 
export class NewJerseyRegistrationService {

    titleCase(str: string): string {
        const a = str.toLowerCase().split(' ');
        for (let i = 0; i < str.length; i++) {
          a[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1); 
        }

        return a.join(' ');
      }

    async checkStatus(voterInformation: VoterInformation): Promise<CheckRegistrationResponse> {
        const response = await this.getStatusFromNJGov(voterInformation)

        const apiResponse: NJVotersApiResponse[]  = response.data

        if (apiResponse.length === 0) {
            return { voterStatus: { type: "notEnrolled", value: { title: "test", message: `dfs`}}}
        } else if (apiResponse.length > 1) {
            console.log("Multiple responses found!")
        }

        const firstResult: NJVotersApiResponse = apiResponse[0]

        return { 
            voterStatus: { 
                type: "singleEnrolled", 
                value: [
                     {
                        title: "Full Name", 
                        message: `${firstResult.firstName} ${firstResult.middleInitial} ${firstResult.lastName}`
                    },
                    {
                        title: "Registered District", 
                        message: `${firstResult.city}, ${firstResult.county}, ${voterInformation.state}`
                    },
                    {
                        title: "Date of Birth", 
                        message: moment(firstResult.dob, "MM-DD-YYYY").format("LL")
                    },
                    {
                        title: "Voting Privilege Date", 
                        message: moment(firstResult.votingPrivilegeDate, "MM-DD-YYYY").format("LL")
                    }
                ]
            }
        }
    }

    private async getStatusFromNJGov(voterInformation: VoterInformation) {
        return await axios({
            url: "https://voter.svrs.nj.gov/api/voters",
            method: "post",
            headers: {
                "content-type": "application/json",
                "accept": "application/json, text/plain, */*"
            },
            data: {
                firstName: `${voterInformation.firstName}`,
                lastName: `${voterInformation.lastName}`,
                dob: `${voterInformation.month.padStart(2, '0')}/${voterInformation.year}`
            }
        });
    }
}