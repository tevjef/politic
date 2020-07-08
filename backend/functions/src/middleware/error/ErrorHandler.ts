import { NextFunction, Request, Response } from 'express';

function errorMiddleware(error: any, request: Request, response: Response, next: NextFunction) {
    const message = error.message || 'Something went wrong';
    const description = error
    response
      .status(500)
      .send({
        code: -1,
        message: message,
        description: description
      })
  }
   
  export default errorMiddleware;