import * as functions from 'firebase-functions';
import * as express from 'express';

import * as voterRollRouter from "./routes/voterRollRoutes"
import errorMiddleware from './middleware/error/ErrorHandler';

const app = express()

app.use("/voterRoll", voterRollRouter.router)
app.use(errorMiddleware)

export const expressApp = functions.https.onRequest(app);
