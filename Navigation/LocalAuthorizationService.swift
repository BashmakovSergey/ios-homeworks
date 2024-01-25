import Foundation
import LocalAuthentication

class LocalAuthorizationService {
    
    static let shared = LocalAuthorizationService()
    
    enum BiometryType {
        case none
        case touchID
        case faceID

        static func currentType() -> BiometryType {
            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return context.biometryType == .faceID ? .faceID : .touchID
            } else {
                return .none
            }
        }
    }

    var availableBiometricType: BiometryType {
        let type = BiometryType.currentType()
        return type
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, Error>) -> Void) {
        var error: NSError?
        guard LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            authorizationFinished(.failure(error ?? NSError()))
            return
        }
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization") { result, error in
            if let error = error {
                authorizationFinished(.failure(error))
            } else {
                authorizationFinished(.success(result))
            }
        }
    }
}
