import { plainToClass } from "class-transformer";
import { validate, ValidationError } from "class-validator";
import * as express from "express";
import * as lodash from "lodash";

export function validationMiddleware<T>(type: any): express.RequestHandler {
  return (req, res, next) => {
    validate(plainToClass(type, req.body))
      .then((errors: ValidationError[]) => {
        if (errors.length > 0) {
          const allErrors = errors.concat(...errors.map((e) => e.children));
          const message = allErrors
            .map((error: ValidationError) =>
              Object.values(error.constraints ?? "")
            )
            .join(", ");
          res.status(400).send({ code: -1, message: message });
        } else {
          const parsedBody: T = req.body;
          if (lodash.isEmpty(parsedBody)) {
            const error = {
              code: -1,
              message: "Invalid request format",
              description: `Could not parse ${JSON.stringify(req.body)}\n${
                new Error().stack
              }`,
            };
            res.status(400).send(error);
            return;
          }

          res.locals.body = parsedBody;

          next();
        }
      })
      .catch((e) =>
        res.status(400).send({ code: -1, message: `Unexpected exception ${e}` })
      );
  };
}

export default validationMiddleware;
