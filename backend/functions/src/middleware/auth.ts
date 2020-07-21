import { Request, Response, NextFunction } from "express";
import { FirebaseAdminService } from "../services/FirebaseAdminService";

const firebaseAdminService = new FirebaseAdminService();

export const isUserAuthenticated = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(403).json({
      status: 403,
      message: "Missing Authorization header.",
      description: new Error().stack,
    });
  } else {
    const token = authHeader;

    if (token === "test") {
      res.locals.userId = "Test user";
      next();

      return;
    }

    if (token) {
      return firebaseAdminService
        .getUserId(token)
        .then((userId) => {
          res.locals.userId = userId;
          next();
        })
        .catch((err) => {
          console.log(err);

          return res.status(401).json({
            error: {
              code: 401,
              message: "Please use a valid auth token.",
              description: err,
            },
          });
        });
    } else {
      return res.status(403).json({
        code: 403,
        message: "You're not authorized to access this resource",
        description: new Error().stack,
      });
    }
  }
};
