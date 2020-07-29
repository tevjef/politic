import { Request, Response, Router } from "express";
import { VoterRollHandler } from "../handlers/VoterRollHandler";
import {
  CheckRegistrationRequest,
  EnrollmentRequest,
  ManualEnrollmentRequest,
} from "../model/VoterRegistration";
import validateBody from "../middleware/validation";
import { isUserAuthenticated } from "../middleware/auth";
import { wrapAsync } from "../middleware/error/ErrorHandler";

const handler = new VoterRollHandler();

const checkRegistration = async (req: Request, res: Response) => {
  const checkRegistrationRequest = <CheckRegistrationRequest>res.locals.body;

  await handler.checkRegistration(checkRegistrationRequest).then((body) => {
    res.set("Cache-Control", "public, max-age=3600, s-maxage=3600");
    res.json(body);
  });
};

const states = async (req: Request, res: Response) => {
  await handler.getStates().then((body) => {
    res.set("Cache-Control", "public, max-age=86400, s-maxage=86400");
    res.json(body);
  });
};

const saveVoterInformation = async (req: Request, res: Response) => {
  const enrollmentRequest = <EnrollmentRequest> res.locals.body;
  const userId = <string>res.locals.userId;

  await handler.saveVoterInformation(userId, enrollmentRequest).then((body) => {
    res.json(body);
  });
};

const manualEnrollment = async (req: Request, res: Response) => {
  const enrollmentRequest = <ManualEnrollmentRequest>res.locals.body;
  const userId = <string>res.locals.userId;

  await handler
    .saveManualUser(userId, enrollmentRequest.enrollment.notificationToken)
    .then((body) => {
      res.json(body);
    });
};

export const router = Router();

// GET /voterRoll/checkRegistration
router.post(
  "/checkRegistration",
  validateBody(CheckRegistrationRequest),
  wrapAsync(checkRegistration)
);

// GET /voterRoll/states
router.get("/states", wrapAsync(states));

// GET /voterRoll/manual
router.post(
  "/manual",
  [isUserAuthenticated, validateBody(ManualEnrollmentRequest)],
  wrapAsync(manualEnrollment)
);

// POST /voterRoll/save
router.post(
  "/save",
  [isUserAuthenticated, validateBody(EnrollmentRequest)],
  wrapAsync(saveVoterInformation)
);
