import { Request, Response } from "express";
import axios from 'axios';

export const testing = async (req: Request, res: Response) => {
    await axios({
        url: "https://voter.svrs.nj.gov/api/voters",
        method: "post",
        headers: { 
            "content-type": "application/json",
            "accept": "application/json, text/plain, */*" 
        },
        data: {
            firstName: "Tevin",
            lastName: "Jeffrey",
            dob: "09/1994"
        }
    })
        .then((body) => { res.send(body.data) })
        .catch ((err) => { res.send(err) });
}