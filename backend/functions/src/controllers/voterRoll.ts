import { Request, Response, Router } from "express";
import { parseBody } from "./util/utils";
import { VoterRollHandler } from "../handlers/voter_roll/VoterRollHandler";
import { CheckRegistrationRequest } from "../model/VoterRegistration";
import validateBody from "../middleware/validation";

const handler = new VoterRollHandler();

const checkRegistration = async (req: Request, res: Response) => {
  const checkRegistrationRequest = parseBody<CheckRegistrationRequest>(
    req,
    res
  );

  handler
    .checkRegistration(checkRegistrationRequest)
    .then((body) => {
      res.set("Cache-Control", "public, max-age=3600, s-maxage=3600");
      res.json(body);
    })
    .catch((err) => {
      res.send(err);
    });
};

const states = async (req: Request, res: Response) => {
  handler
    .getStates()
    .then((body) => {
      res.set("Cache-Control", "public, max-age=86400, s-maxage=86400");
      res.json(body);
    })
    .catch((err) => {
      res.send(err);
    });
};

export const router = Router();

router.post(
  "/checkRegistration",
  validateBody(CheckRegistrationRequest),
  checkRegistration
);
router.get("/states", states);
