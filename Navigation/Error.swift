import Foundation

enum LoginError: Error {
    case userNotFound
    case wrongPassword
    case userNotFoundAndWrongPassword
    case tooStrongPassword
}

enum mediaError: Error {
    case musicError
}

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case notFound
    case serverError
    case unowned
    case decodeError
}
