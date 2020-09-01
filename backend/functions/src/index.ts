import * as functions from 'firebase-functions';
import express from 'express';

import * as voterRoll from "./controllers/voterRoll";
import * as dataFeeds from "./controllers/dataFeeds";
import * as user from "./controllers/user";
import * as maps from "./controllers/maps";
import errorMiddleware from './middleware/error/ErrorHandler';

const app = express()

app.use("/voterRoll", voterRoll.router);
app.use("/feeds", dataFeeds.router);
app.use("/user", user.router);
app.use("/maps", maps.router);
app.use(errorMiddleware)

export const expressApp = functions.https.onRequest(app);
