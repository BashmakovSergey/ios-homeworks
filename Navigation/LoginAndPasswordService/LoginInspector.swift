import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    
    func check(inputLogin: String, inputPassword: String) throws -> Bool
    
    func passwordSelection()
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

class LoginInspector: LoginViewControllerDelegate {
    
    func check(inputLogin: String, inputPassword: String) throws -> Bool {
        let isCorrectLogin = Checker.shared.checkLoginOnly(inputLogin: inputLogin)
        let isCorrectPassword = Checker.shared.checkPasswordOnly(inputPassword: inputPassword)
        guard isCorrectLogin else {
            throw isCorrectPassword ? LoginError.userNotFound : LoginError.userNotFoundAndWrongPassword
        }
        guard isCorrectPassword else {
            throw LoginError.wrongPassword
        }
        return isCorrectLogin && isCorrectPassword
    }
    
    private func randomPassword() -> String {
        let allowedCharacters:[String] = String().printable.map { String($0) }
        let randomInt = Int.random(in: 3..<9)
        var passWord = ""
        for _ in 0 ..< randomInt {
            guard let samSymbols = allowedCharacters.randomElement() else {return ""}
            passWord.append(samSymbols)
        }
        return passWord
    }
    
    func passwordSelection(){
        Checker.shared.setNewPassword(newPassword: randomPassword())
    }
    
}

struct MyLogInFactory: LoginFactory {
    
    private let inspector = LoginInspector()
    
    func makeLoginInspector() -> LoginInspector {
        return inspector
    }
    
}
