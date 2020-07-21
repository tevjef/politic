import * as admin from "firebase-admin";
import { VoterInformation } from "../model/VoterRegistration";
import { Location } from "../model/User";

admin.initializeApp();
const auth = admin.auth();
const firestore = admin.firestore();

const COLLECTION_LOCATIONS = "locations";
const COLLECTION_ELECTORAL_REGISTER = "electoral_register";
const COLLECTION_NOTIFICATIONS_AUTH_TOKENS = "notification_auth_tokens";

export class FirebaseAdminService {
  
  async getUserId(token: string): Promise<string> {
    const value = await auth.verifyIdToken(token, true);
    return value.uid;
  }

  async getLocation(userId: string): Promise<Location> {
    return firestore
      .collection(COLLECTION_LOCATIONS)
      .doc(userId)
      .get()
      .then((value) => {
        if (!value.exists) throw new FirestoreReadError(value);
        return value;
      })
      .then((value) => <Location>value.data());
  }

  async updateLocation(userId: string, location: Location): Promise<Location> {
    return firestore
      .collection(COLLECTION_LOCATIONS)
      .doc(userId)
      .set({ location: location })
      .then((value) => {
        console.log(
          `${value.writeTime.toDate()}: updating location user: ${userId}`
        );
        return location;
      });
  }

  async updateVoterInformation(
    userId: string,
    voterInformation: VoterInformation
  ): Promise<VoterInformation> {
    return firestore
      .collection(COLLECTION_ELECTORAL_REGISTER)
      .doc(userId)
      .set({ voterInformation: voterInformation })
      .then((value) => {
        console.log(
          `${value.writeTime.toDate()}: updating voter information user: ${userId} state: ${voterInformation.state} `
        );

        return voterInformation;
      });
  }

  async updateNotificationToken(
    userId: string,
    notificationToken: string
  ): Promise<string> {
    return firestore
      .collection(COLLECTION_NOTIFICATIONS_AUTH_TOKENS)
      .doc(userId)
      .set({ token: notificationToken })
      .then((value) => {
        console.log(
          `${value.writeTime.toDate()}: updating notification token: ${notificationToken} user: ${userId}`
        );
        return notificationToken;
      });
  }
}

class FirestoreReadError extends Error {
  constructor(
    message: FirebaseFirestore.DocumentSnapshot<FirebaseFirestore.DocumentData>
  ) {
    super(`Error when reading: ${message.ref.path}`);
  }
}
