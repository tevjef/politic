import * as admin from "firebase-admin";
import { VoterInformation } from "../model/VoterRegistration";
import { Location } from "../model/User";
import { UploadOptions } from "@google-cloud/storage";
import { v4 as uuidv4 } from "uuid";

admin.initializeApp();
const auth = admin.auth();
const firestore = admin.firestore();
const bucket = admin.storage().bucket();

const COLLECTION_LOCATIONS = "locations";
const COLLECTION_ELECTORAL_REGISTER = "electoral_register";
const COLLECTION_NOTIFICATIONS_AUTH_TOKENS = "notification_auth_tokens";

export class FirebaseAdminService {
  async getUserId(token: string): Promise<string> {
    const value = await auth.verifyIdToken(token, true);
    console.log("TOKEN: " + token);
    console.log("USERID: " + value.uid);

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
      .set(location)
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
          `${value.writeTime.toDate()}: updating voter information user: ${userId} state: ${
            voterInformation.state
          } `
        );

        return voterInformation;
      });
  }

  async manualEnrollment(userId: string, date: Date): Promise<undefined> {
    return firestore
      .collection(COLLECTION_ELECTORAL_REGISTER)
      .doc(userId)
      .set({ manualMarkedEnrolled: date.getTime() })
      .then((value) => {
        console.log(
          `${value.writeTime.toDate()}: data: ${date.getTime()} manual enrollment user: ${userId}`
        );
        return undefined;
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

  async getImageKey(address: string): Promise<string> {
    const obj = await firestore.collection("map_locations").doc(address).get();

    if (obj.exists) {
      return (<UUIDObject>obj.data()).uuid;
    } else {
      await firestore
        .collection("map_locations")
        .doc(address)
        .set({ uuid: uuidv4() })
        .then((value) => {
          console.log(`${value.writeTime.toDate()}: writing image`);
          return value;
        });

      return await this.getImageKey(address);
    }
  }

  async getLocationPhoto(key: string): Promise<string | undefined> {
    const filePath = `app/public/polling-locations/${key}.png`;
    const downloadPath = `app%2Fpublic%2Fpolling-locations%2F${key}.png`;
    const exists = await bucket
      .file(filePath)
      .exists()
      .then((value) => value[0])
      .catch((err) => undefined);

    if (exists) {
      return `https://firebasestorage.googleapis.com/v0/b/byteflip-politic.appspot.com/o/${downloadPath}?alt=media`;
    } else {
      return undefined;
    }
  }

  async uploadLocationPhoto(path: string, key: string): Promise<string> {
    const filePath = `app/public/polling-locations/${key}.png`;
    const options = <UploadOptions>{
      destination: filePath,
      contentType: "image/png",
      metadata: {
        metadata: {
          firebaseStorageDownloadTokens: uuidv4(),
          cacheControl: "public, max-age=31536000",
        },
      },
    };

    await bucket.upload(path, options);

    const downloadPath = `app%2Fpublic%2Fpolling-locations%2F${key}.png`;
    return `https://firebasestorage.googleapis.com/v0/b/byteflip-politic.appspot.com/o/${downloadPath}?alt=media`;
  }
}

interface UUIDObject {
  uuid: string;
}

export class FirestoreReadError extends Error {
  constructor(
    message: FirebaseFirestore.DocumentSnapshot<FirebaseFirestore.DocumentData>
  ) {
    super(`Error when reading: ${message.ref.path}`);
  }
}
