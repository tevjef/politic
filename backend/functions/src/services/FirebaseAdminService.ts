import * as admin from "firebase-admin";
import { VoterInformation } from "../model/VoterRegistration";

admin.initializeApp();
const auth = admin.auth();
const firestore = admin.firestore();

const COLLECTION_ELECTORAL_REGISTER = "electoral_register";
const COLLECTION_NOTIFICATIONS_AUTH_TOKENS = "notification_auth_tokens";

export class FirebaseAdminService {
  async getUserUUID(token: string): Promise<string> {
    const value = await auth.verifyIdToken(token, true);
    return value.uid;
  }

  async addVoterInformation(
    userUUID: string,
    voterInformation: VoterInformation
  ): Promise<VoterInformation> {
    return firestore
      .collection(COLLECTION_ELECTORAL_REGISTER)
      .doc(userUUID)
      .set({ voterInformation: voterInformation })
      .then((value) => {
        console.log(
          `${value.writeTime.toDate}: adding voter information user: ${userUUID} state: ${voterInformation.state} `
        );

        return voterInformation;
      });
  }

  async addNotificationToken(
    userUUID: string,
    notificationToken: string
  ): Promise<string> {
    return firestore
      .collection(COLLECTION_NOTIFICATIONS_AUTH_TOKENS)
      .doc(userUUID)
      .set({ token: notificationToken })
      .then((value) => {
        console.log(
          `${value.writeTime.toDate}: adding notification token: ${notificationToken} user: ${userUUID}`
        );
        return notificationToken;
      });
  }
}
