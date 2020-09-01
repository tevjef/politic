import { Request, Response, Router } from "express";
import { DataFeedsHandler } from "../handlers/DateFeedsHandler";
import { isUserAuthenticated } from "../middleware/auth";
import { wrapAsync } from "../middleware/error/ErrorHandler";

const handler = new DataFeedsHandler();

export const stateFeed = async (req: Request, res: Response) => {
  const congressionalDistrict = <string>req.query.cd ?? "";
  await handler
    .getStateFeed(req.params["state"], congressionalDistrict)
    .then((body) => {
      res.set("Cache-Control", "public, max-age=600, s-maxage=600");
      res.json(body);
    });
};

export const getRepresentatives = async (req: Request, res: Response) => {
  const userId = <string>res.locals.userId;

  await handler.getRepresentatives(userId).then((body) => {
    res.json(body);
  });
};

export const getUserVoterInfo = async (req: Request, res: Response) => {
  const userId = <string>res.locals.userId;

  await handler.getUserVoterInfo(userId).then((body) => {
    res.json(body);
  });
};

export const getElection = async (req: Request, res: Response) => {
  const userId = <string>res.locals.userId;

  await handler.getElection(userId, req.params["id"]).then((body) => {
    res.json(body);
  });
};

export const getAllElections = async (req: Request, res: Response) => {
  await handler.getAllElections().then((body) => {
    res.json(body);
  });
};

export const router = Router();

router.get("/states/:state", wrapAsync(stateFeed));
router.get(
  "/representatives",
  [isUserAuthenticated],
  wrapAsync(getRepresentatives)
);
router.get("/elections/all", wrapAsync(getAllElections));
router.get("/elections/:id", [isUserAuthenticated], wrapAsync(getElection));
router.get("/elections", [isUserAuthenticated], wrapAsync(getUserVoterInfo));

