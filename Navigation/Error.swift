import Foundation

enum LoginError: Error {
    case userNotFound
    case wrongPassword
    case userNotFoundAndWrongPassword
    case tooStrongPassword
    case suchUserAlreadyExists
    case authorized
    case successful
}

enum mediaError: Error {
    case musicError
}

enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case decodeError = 1000
    case serverError = 500
    case unowned = 2000
}
