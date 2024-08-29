import {OpenpathError} from "./OpenpathError";

export class OpenpathLoginCancelledError extends OpenpathError {
    constructor() {
        super('Login cancelled');
    }
}
