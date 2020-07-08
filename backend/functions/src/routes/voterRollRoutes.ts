import * as express from 'express';
import * as voterRollController from "../controllers/voterRollController"
import validateBody from '../middleware/validation';
import { CheckRegistrationRequest } from '../model/VoterRegistration';

export const router = express.Router();

router.post("/checkRegistration", validateBody(CheckRegistrationRequest), voterRollController.checkRegistration)
router.get("/states", voterRollController.states)