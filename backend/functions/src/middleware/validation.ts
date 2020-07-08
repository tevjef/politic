import { plainToClass } from "class-transformer";
import { validate, ValidationError } from "class-validator";
import * as express from "express";

export function validationMiddleware<T>(type: any): express.RequestHandler {
  return (req, res, next) => {
    validate(plainToClass(type, req.body)).then((errors: ValidationError[]) => {
      if (errors.length > 0) {
        const allErrors = errors.concat(...errors.map((e) => e.children));
        const message = allErrors
          .map((error: ValidationError) =>
            Object.values(error.constraints ?? "")
          )
          .join(", ");
        res.status(400).send({ code: -1, message: message });
      } else {
        next();
      }
    });
  };
}

export default validationMiddleware;
