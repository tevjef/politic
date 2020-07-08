import *  as lodash from "lodash";
import { Request, Response } from "express";

export function parseBody<T>(req: Request, res: Response): T {
    const parsedBody: T = req.body
    if (lodash.isEmpty(parsedBody)) {
        const error = { code: -1, message: "Invalid request format", description: `Could not parse ${JSON.stringify(req.body)}\n${new Error().stack}`}
        res
            .status(400)
            .send(error)
    }
    return parsedBody
}