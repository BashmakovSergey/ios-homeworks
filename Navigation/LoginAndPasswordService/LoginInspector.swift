import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func check(inputLogin: String, inputPassword: String) -> Bool
    
    func checkLoginOnly(inputLogin: String) -> Bool
    
    func checkPasswordOnly(inputPassword: String) -> Bool
    
    func passwordSelection()
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

class LoginInspector: LoginViewControllerDelegate {
    
    func checkLoginOnly(inputLogin: String) -> Bool {
        return Checker.shared.checkLoginOnly(inputLogin: inputLogin)
    }
    
    func checkPasswordOnly(inputPassword: String) -> Bool {
        return Checker.shared.checkPasswordOnly(inputPassword: inputPassword)
    }
    
    func check(inputLogin: String, inputPassword: String) -> Bool {
        return Checker.shared.check(inputLogin: inputLogin, inputPassword: inputPassword)
    }
    
    private func randomPassword() -> String {
        let allowedCharacters:[String] = String().printable.map { String($0) }
        let randomInt = Int.random(in: 3..<6)
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
