import * as functions from 'firebase-functions';
import * as express from 'express';

import * as voterRollRouter from "./routes/voterRollRoutes"

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

const app = express()

app.use("/voterRoll", voterRollRouter.router)

export const expressApp = functions.https.onRequest(app);
