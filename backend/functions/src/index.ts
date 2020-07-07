import * as functions from 'firebase-functions';
import * as express from 'express';

import * as voterRollRouter from "./routes/voterRollRoutes"

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

const app = express()

app.use("/voterRoll", voterRollRouter.router)

// fetch("https://voter.svrs.nj.gov/api/voters", {
//   "headers": {
//     "accept": "application/json, text/plain, */*",
//     "sec-fetch-mode": "cors",
//     "sec-fetch-site": "same-origin",
//     "cookie": "visid_incap_1909031=uaf4ehbWTsuiSU5h9fOYe0YEoV4AAAAAQUIPAAAAAACJhv8OzVjjRTQW0OOm0Kd7; incap_ses_701_1909031=U6fDMaOcRWSHyPmH2XO6Cd36914AAAAArQ/BBF64F0SOS3Iyv8VMhw==; incap_ses_702_1909031=J52PNeydohQ4wZTMagG+CYuJ/14AAAAAhpFoV2lKgYC4OJ6WBDAjAQ==; WT_FPC=id=20d20af11ffe257090f1583622108704:lv=1593801627439:ss=1593801627439; __cfduid=d59fa062266142d0fbd98e8ae935a31891593814409; session=t1_3SgXucrTLDxLxkGmC8A..|1593818009|03HPs7MNJmndtKX2gBzfPNBr7Nb1_HUP2I-MB3L6-_vM1xvPTVkV5y7MSirfKFKRRtOUQ5WV9ukjGI_IDw5yKLEc836bs3Q3Gvg4cJLkNCrlVNJiuiZ40OUMtaqalnVY|0uzPLUmCjUzXW9RCdnN85hihxDs."
//   },
//   "referrer": "https://voter.svrs.nj.gov/registration-check/results?firstName=Tevin&middleInitial=&lastName=Jeffrey&dob=09%2F1994",
//   "referrerPolicy": "no-referrer-when-downgrade",
//   "body": "{\"firstName\":\"Tevin\",\"middleInitial\":\"\",\"lastName\":\"Jeffrey\",\"dob\":\"09/1994\"}",
//   "method": "POST",
//   "mode": "cors"
// });

export const expressApp = functions.https.onRequest(app);
