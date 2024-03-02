public enum HttpError: Error {
    case noConnectivityError,
         badRequest,
         serverError,
         unauthorized,
         forbidden
}
