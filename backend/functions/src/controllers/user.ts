import { Request, Response, Router, NextFunction } from "express";
import validateBody from "../middleware/validation";
import { UserHandler } from "../handlers/UserHandler";
import { LocationUpdateRequest, NotificationTokenUpdateRequest } from "../model/User";
import { isUserAuthenticated } from "../middleware/auth";

const handler = new UserHandler();

const getLocation = async (req: Request, res: Response) => {
  const userId = <string>res.locals.userId;
  await handler.getLocation(userId).then((body) => {
    res.json(body);
  });
};

const updateLocation = async (req: Request, res: Response) => {
  const request = <LocationUpdateRequest>res.locals.body;
  const userId = <string>res.locals.userId;
  await handler.updateLocation(userId, request.locationUpdate).then((body) => {
    res.json(body);
  });
};

const updateNotificationToken = async (req: Request, res: Response) => {
  const request = <NotificationTokenUpdateRequest>res.locals.body;
  const userId = <string>res.locals.userId;
  await handler.updateToken(userId, request.tokenUpdate).then((body) => {
    res.json(body);
  });
};

export const router = Router();

// POST /user/notificationToken
router.post(
  "/notificationToken",
  [isUserAuthenticated, validateBody(NotificationTokenUpdateRequest)],
  wrapAsync(updateNotificationToken)
);

// POST /user/location
router.post(
  "/location",
  [isUserAuthenticated, validateBody(LocationUpdateRequest)],
  wrapAsync(updateLocation)
);

// GET /user/location
router.get("/location", [isUserAuthenticated], wrapAsync(getLocation));

function wrapAsync(fn: any) {
  return function (req: Request, res: Response, next: NextFunction) {
    // Make sure to `.catch()` any errors and pass them along to the `next()`
    // middleware in the chain, in this case the error handler.
    fn(req, res, next).catch(next);
  };
}
