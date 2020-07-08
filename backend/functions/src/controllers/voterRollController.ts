import { Request, Response } from "express";
import { parseBody } from "./util/utils";
import { VoterRollHandler } from '../handlers/voter_roll/VoterRollHandler'
import { CheckRegistrationRequest } from '../model/VoterRegistration'

const handler = new VoterRollHandler()

export const checkRegistration = async (req: Request, res: Response) => {
    const checkRegistrationRequest = parseBody<CheckRegistrationRequest>(req, res)

    handler.checkRegistration(checkRegistrationRequest)
        .then((body) => { 
            res.set('Cache-Control', 'public, max-age=3600, s-maxage=3600');
            res.json(body) 
        }) 
        .catch ((err) => { res.send(err) });
}

export const states = async (req: Request, res: Response) => {
    handler.getStates()
        .then((body) => { 
            res.set('Cache-Control', 'public, max-age=86400, s-maxage=86400');
            res.json(body) }) 
        .catch ((err) => { 
            res.send(err) });
}