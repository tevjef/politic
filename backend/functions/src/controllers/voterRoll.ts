import { Request, Response, Router } from "express";
import { parseBody } from "./util/utils";
import { VoterRollHandler } from "../handlers/VoterRollHandler";
import {
  CheckRegistrationRequest,
  EnrollmentRequest,
} from "../model/VoterRegistration";
import validateBody from "../middleware/validation";
import { isUserAuthenticated } from "../middleware/auth";

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
const saveVoterInformation = async (req: Request, res: Response) => {
    const enrollmentRequest = parseBody<EnrollmentRequest>(req, res);
    const userUUID = <string>res.locals.usrUUID;

    handler
      .saveVoterInformation(userUUID, enrollmentRequest)
      .then((body) => {
        res.json(body);
      })
      .catch((err) => {
        res.send(err);
      });
};

export const router = Router();

// GET /voterRoll/checkRegistration
router.post(
  "/checkRegistration",
  validateBody(CheckRegistrationRequest),
  checkRegistration
);

// GET /voterRoll/states
router.get("/states", states);

// POST /voterRoll/save
router.post(
  "/save",
  [isUserAuthenticated, validateBody(EnrollmentRequest)],
  saveVoterInformation
);
