import * as express from 'express';

import * as voterRollController from "../controllers/voterRollController"

export const router = express.Router();

router.get("/check", voterRollController.testing)