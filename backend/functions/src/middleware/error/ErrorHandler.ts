import { NextFunction, Request, Response } from "express";

function errorMiddleware(
  error: any,
  request: Request,
  response: Response,
  next: NextFunction
) {
  const message = error.message || "Something went wrong";
  let description = error;
  if (error instanceof Error) {
    description = error;
  }
  console.log(error);
  response.status(500).send({
    code: -1,
    message: message,
    description: description,
  });
}

export default errorMiddleware;

export function wrapAsync(fn: any) {
  return function (req: Request, res: Response, next: NextFunction) {
    // Make sure to `.catch()` any errors and pass them along to the `next()`
    // middleware in the chain, in this case the error handler.
    fn(req, res, next).catch(next);
  };
}
