import { Request, Response, Router } from "express";
import { DataFeedsHandler } from "../handlers/voter_roll/DateFeedsHandler";

const handler = new DataFeedsHandler()

export const stateFeed = async (req: Request, res: Response) => {
    handler.getStateFeed(req.params["state"])
        .then((body) => { 
            res.set('Cache-Control', 'public, max-age=600, s-maxage=600');
            res.json(body) 
        }) 
        .catch ((err) => { res.send(err) });
}

export const router = Router();

router.get("/states/:state", stateFeed);
