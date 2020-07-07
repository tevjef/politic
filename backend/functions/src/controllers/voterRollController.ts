import { Request, Response } from "express";

import { VoterRollHandler } from '../handlers/voter_roll/VoterRollHandler'
import { CheckRegistrationRequest } from '../model/VoterRegistration'

const handler = new VoterRollHandler()

export const checkRegistration = async (req: Request, res: Response) => {
        const checkRegistrationRequest: CheckRegistrationRequest = req.body

        handler.checkRegistration(checkRegistrationRequest)
            .then((body) => { res.send(JSON.stringify(body)) }) 
            .catch ((err) => { res.send(err) });
}