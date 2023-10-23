import Foundation

enum LoginError: Error {
    case userNotFound
    case wrongPassword
    case userNotFoundAndWrongPassword
    case tooStrongPassword
}
