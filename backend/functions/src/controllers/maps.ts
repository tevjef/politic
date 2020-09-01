import { Request, Response, Router } from "express";
import { wrapAsync } from "../middleware/error/ErrorHandler";
import { MapsHandler } from "../handlers/MapsHandler";

const handler = new MapsHandler();

const getPlace = async (req: Request, res: Response) => {
  const searchInput = <string>req.query.input ?? "";
  await handler.autocomplete(searchInput).then((body) => {
    res.json(body);
  });
};

export const router = Router();

// GET /maps/autocomplete?input=<>
router.get("/autocomplete", wrapAsync(getPlace));
