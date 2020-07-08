import { 
    CheckRegistrationRequest, 
    CheckRegistrationResponse,
    StatesResponse
} from '../../model/VoterRegistration'
import { DefaultRegistrationProvider } from './states/DefaultRegistrationProvider'
import { NewJerseyRegistrationProvider } from './states/NewJerseyRegistrationProvider'
import { ProviderMap } from './StatusProvider';

const defaultProvider = new DefaultRegistrationProvider()

const statusProviders: ProviderMap = {
    "NJ" : new NewJerseyRegistrationProvider()
}

export class VoterRollHandler {
    async checkRegistration(request: CheckRegistrationRequest): Promise<CheckRegistrationResponse> {
        const provider = statusProviders[request.voterInformation.state] ?? defaultProvider
        return provider.checkStatus(request.voterInformation)
    }

    async getStates(): Promise<StatesResponse> {
        return { states: Object.entries(states).map(([key, value]) => {
            const provider = statusProviders[key] ?? defaultProvider
            return {
                name: value,
                abbreviation: key,
                fields: provider.fields()
            }
        }) }
    }
}

const states = {
    "AL": "Alabama",
    "AK": "Alaska",
    "AZ": "Arizona",
    "AR": "Arkansas",
    "CA": "California",
    "CO": "Colorado",
    "CT": "Connecticut",
    "DE": "Delaware",
    "DC": "District of Columbia",
    "FL": "Florida",
    "GA": "Georgia",
    "HI": "Hawaii",
    "ID": "Idaho",
    "IL": "Illinois",
    "IN": "Indiana",
    "IA": "Iowa",
    "KS": "Kansas",
    "KY": "Kentucky",
    "LA": "Louisiana",
    "ME": "Maine",
    "MD": "Maryland",
    "MA": "Massachusetts",
    "MI": "Michigan",
    "MN": "Minnesota",
    "MS": "Mississippi",
    "MO": "Missouri",
    "MT": "Montana",
    "NE": "Nebraska",
    "NV": "Nevada",
    "NH": "New Hampshire",
    "NJ": "New Jersey",
    "NM": "New Mexico",
    "NY": "New York",
    "NC": "North Carolina",
    "ND": "North Dakota",
    "OH": "Ohio",
    "OK": "Oklahoma",
    "OR": "Oregon",
    "PA": "Pennsylvania",
    "RI": "Rhode Island",
    "SC": "South Carolina",
    "SD": "South Dakota",
    "TN": "Tennessee",
    "TX": "Texas",
    "UT": "Utah",
    "VT": "Vermont",
    "VA": "Virginia",
    "WA": "Washington",
    "WV": "West Virginia",
    "WI": "Wisconsin",
    "WY": "Wyoming",
    "GU": "Guam",
    "PR": "Puerto Rico",
    "AA": "U.S. Armed Forces – Americas",
    "AE": "U.S. Armed Forces – Europe",
    "AP": "U.S. Armed Forces – Pacific",
    "VI": "U.S. Virgin Islands"
  }