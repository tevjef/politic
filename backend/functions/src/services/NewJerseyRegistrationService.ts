import { VoterInformation, CheckRegistrationResponse } from '../model/VoterRegistration';
import axios from 'axios';
import * as moment from 'moment';


/* 
>  [
>    {
>      firstName: 'TEVIN',
>      middleInitial: 'W',
>      lastName: 'JEFFREY',
>      county: 'Essex',
>      city: 'Newark City',
>      dob: '09/16/1994',
>      votingPrivilegeDate: '06/04/2013'
>    }
>  ]
 */

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
        const response = await axios({
            url: "https://voter.svrs.nj.gov/api/voters",
            method: "post",
            headers: { 
                "content-type": "application/json",
                "accept": "application/json, text/plain, */*" 
            },
            data: {
                firstName: `${voterInformation.firstName}`,
                lastName: `${voterInformation.lastName}`,
                dob: `${voterInformation.month}/${voterInformation.year}`
            }
        })

        const apiResponse: NJVotersApiResponse[]  = response.data
        if (apiResponse.length === 0) {
            return { voterStatus: { type: "notEnrolled", value: { title: "test", message: `dfs`}}}
        }

        const firstResult: NJVotersApiResponse = apiResponse[0] 

        const name = `${firstResult.firstName} ${firstResult.middleInitial} ${firstResult.lastName}`
        
        const district = `${firstResult.city}, ${firstResult.county}, ${voterInformation.state}`
        
        const dob = moment(firstResult.dob, "MM-DD-YYYY").format("LL")
        
        const privilegeDate = moment(firstResult.votingPrivilegeDate, "MM-DD-YYYY").format("LL")

        return { 
            voterStatus: { 
                type: "singleEnrolled", 
                value: [
                     {
                        title: "Full Name", 
                        message: `${name}`
                    },
                    {
                        title: "Registered District", 
                        message: `${district}`
                    },
                    {
                        title: "Date of Birth", 
                        message: `${dob}`
                    },
                    {
                        title: "Voting Privilege Date", 
                        message: `${privilegeDate}`
                    }
                ]
            }
        }
    }
}