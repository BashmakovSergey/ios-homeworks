import Foundation

protocol LoginViewControllerDelegate {
    func checkCredentials(email: String, password: String) async throws -> User?
    func SignUp(email: String, password: String) async throws -> User?
    func isValidEmail(_ email: String) -> Bool
}

class LoginInspector: LoginViewControllerDelegate {
    var checker = CheckerService()
   
    func checkCredentials(email: String, password: String) async throws  -> User? {
        var user: User?
        do {
            user = try await checker.checkCredentials(email: email, password: password)
        } catch {
            throw error
        }
        return user
    }
    
    func SignUp(email: String, password: String) async throws -> User? {
        let user: User?
        do {
            user = try await checker.signUp(email: email, password: password)
        } catch {
            throw error
        }
        return user
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
